# monster_token_manager.gd
extends Node

# Reference to the Solana bridge
onready var solana_bridge = $"../SolanaBridge"  # Adjust path as needed

# Token reward values for each monster type
const token_rewards = {
    Monsters.SLIME: 1,
    Monsters.RED_SLIME: 2,
    Monsters.MUSHROOM: 3
}

func _ready():
    # Connect to the game's monster defeat signal
    # This depends on where/how your game signals monster defeats
    # You might need to adjust this based on your game's structure
    var game_manager = get_tree().get_nodes_in_group("game_manager")
    if game_manager.size() > 0:
        if game_manager[0].has_signal("monster_defeated"):
            game_manager[0].connect("monster_defeated", self, "_on_monster_defeated")

# Called when a monster is defeated
func _on_monster_defeated(monster_type):
    # Calculate reward based on monster type
    var reward = get_token_reward(monster_type)
    
    # Award tokens via Solana
    solana_bridge.reward_tokens(reward)
    
    # Optional: Show feedback to player
    print("Earned " + str(reward) + " tokens for defeating monster!")

# Get token reward amount based on monster type
func get_token_reward(monster_type):
    if token_rewards.has(monster_type):
        return token_rewards[monster_type]
    return 1  # Default reward
