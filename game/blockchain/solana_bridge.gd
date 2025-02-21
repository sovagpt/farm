# solana_bridge.gd - Simplified token-only version
extends Node

signal wallet_connected(public_key)
signal wallet_disconnected
signal token_balance_updated(amount)
signal error_occurred(message)

# JavaScript interface
var _js_callback = JavaScript.create_callback(self, "_on_js_callback")
var _js_interface

func _ready():
	# Wait a moment to ensure the JS is fully loaded
	yield(get_tree().create_timer(0.5), "timeout")
	_initialize_js_interface()

func _initialize_js_interface():
	if OS.has_feature("JavaScript"):
		# Check if our JS integration exists
		var exists = JavaScript.eval("(typeof window.SolanaGameIntegration !== 'undefined')")
		
		if exists:
			# Create the interface
			_js_interface = JavaScript.eval("new window.SolanaGameIntegration()")
			
			# Initialize with your token mint address
			var token_mint = "YOUR_TOKEN_MINT_ADDRESS"  # Replace with your actual token address
			JavaScript.eval("window.solanaInterface.initialize('%s')" % token_mint)
			
			print("Solana interface initialized")
		else:
			push_error("Solana integration JS not found. Make sure to include solana_integration.js")
	else:
		push_error("JavaScript not available in this environment")

func connect_wallet():
	if not _js_interface:
		emit_signal("error_occurred", "Solana integration not initialized")
		return
		
	JavaScript.eval("""
		window.solanaInterface.connectWallet().then(result => {
			window.godot_callback(%d, JSON.stringify({
				type: 'connect_result',
				data: result
			}));
		});
	""" % _js_callback.id)

func disconnect_wallet():
	if not _js_interface:
		return
		
	JavaScript.eval("""
		window.solanaInterface.disconnectWallet().then(result => {
			window.godot_callback(%d, JSON.stringify({
				type: 'disconnect_result',
				data: result
			}));
		});
	""" % _js_callback.id)

func reward_tokens(amount):
	if not _js_interface:
		emit_signal("error_occurred", "Solana integration not initialized")
		return
		
	JavaScript.eval("""
		window.solanaInterface.rewardTokens(%d).then(result => {
			window.godot_callback(%d, JSON.stringify({
				type: 'reward_tokens_result',
				data: result
			}));
		});
	""" % [amount, _js_callback.id])

func get_game_state():
	if not _js_interface:
		emit_signal("error_occurred", "Solana integration not initialized")
		return null
		
	var state_json = JavaScript.eval("JSON.stringify(window.solanaInterface.getGameState())")
	return JSON.parse(state_json).result

func _on_js_callback(args):
	var data = JSON.parse(args[0]).result
	
	match data.type:
		"connect_result":
			if data.data.success:
				emit_signal("wallet_connected", data.data.publicKey)
			else:
				emit_signal("error_occurred", data.data.error)
		
		"disconnect_result":
			if data.data.success:
				emit_signal("wallet_disconnected")
			else:
				emit_signal("error_occurred", data.data.error)
		
		"reward_tokens_result":
			if data.data.success:
				# Update token balance
				var game_state = get_game_state()
				emit_signal("token_balance_updated", game_state.playerTokens)
			else:
				emit_signal("error_occurred", data.data.error)