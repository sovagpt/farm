# wallet_ui.gd
extends CanvasLayer

onready var connect_button = $Control/ConnectButton
onready var address_label = $Control/AddressLabel
onready var balance_label = $Control/BalanceLabel
onready var solana_bridge = $SolanaBridge

func _ready():
    # Connect signals
    connect_button.connect("pressed", self, "_on_connect_pressed")
    solana_bridge.connect("wallet_connected", self, "_on_wallet_connected")
    solana_bridge.connect("token_balance_updated", self, "_on_balance_updated")
    
    # Hide address by default
    address_label.text = "Not connected"
    balance_label.text = "Tokens: 0"

func _on_connect_pressed():
    solana_bridge.connect_wallet()

func _on_wallet_connected(public_key):
    address_label.text = "Connected: " + public_key.substr(0, 6) + "..." + public_key.substr(-4)
    
    # Get initial balance
    var game_state = solana_bridge.get_game_state()
    if game_state:
        balance_label.text = "Tokens: " + str(game_state.playerTokens)

func _on_balance_updated(amount):
    balance_label.text = "Tokens: " + str(amount)
