# monsters_token_manager.gd
extends Node

# Reference to the Solana bridge
onready var solana_bridge = $"../SolanaBridge"  # Adjust path as needed

# Reference to your existing monsters system
export(NodePath) var monsters_manager_path
var monsters_manager

func _ready():
    # Get reference to monsters manager
    if monsters_manager_path:
        monsters_manager = get_node(monsters_manager_path)
        
        # Connect to relevant signals if your monsters have them
        # Example: If monsters emit a "harvested" or "fed" signal
        # Connect to monsters signals based on your implementation
        _connect_monster_signals()

# Connect to all monster signals
func _connect_monster_signals():
    # This depends on how your monsters system is implemented
    # You might need to iterate through monsters or connect to a manager
    
    # Example if you have a signal for harvesting/collecting from monsters:
    # monsters_manager.connect("monster_harvested", self, "_on_monster_harvested")
    
    # Or if each monster emits its own signal:
    for monster in monsters_manager.get_children():
        if monster.has_signal("harvested"):
            monster.connect("harvested", self, "_on_monster_harvested")

# Handle monster harvests/interactions that should reward tokens
func _on_monster_harvested(product_or_monster_type, amount):
    # Calculate token reward based on your game design
    var token_reward = calculate_token_reward(product_or_monster_type, amount)
    
    # Reward tokens via Solana
    solana_bridge.reward_tokens(token_reward)
    
    print("Rewarded " + str(token_reward) + " tokens for monster interaction")

# Calculate token rewards based on monster type/product and amount
func calculate_token_reward(product_or_monster_type, amount):
    # Customize this based on your game economy
    var base_reward = 1
    
    # Different rewards for different monster types or products
    match product_or_monster_type:
        "rare_monster":
            base_reward = 5
        "common_monster":
            base_reward = 2
        # Add more types based on your game
        _:
            base_reward = 1
    
    return base_reward * amount
