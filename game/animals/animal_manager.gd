# animal_manager.gd
extends Node2D

export(PackedScene) var cow_scene
export(PackedScene) var chicken_scene
export(PackedScene) var pig_scene
# Add more animal types as needed

onready var solana_bridge = $"../WalletUI/SolanaBridge"  # Adjust path as needed

func _ready():
    # Initialize animal system
    pass

func create_animal(animal_type, position):
    var scene
    
    match animal_type:
        "cow":
            scene = cow_scene
        "chicken":
            scene = chicken_scene
        "pig":
            scene = pig_scene
        _:
            return null
    
    var animal = scene.instance()
    animal.position = position
    add_child(animal)
    
    # Connect signals
    animal.connect("harvested", self, "_on_animal_harvested")
    
    return animal

func _on_animal_harvested(product, amount):
    # Reward player with tokens based on product and amount
    var token_amount = calculate_token_reward(product, amount)
    solana_bridge.reward_tokens(token_amount)
    
    print("Harvested " + str(amount) + " " + product + ", earned " + str(token_amount) + " tokens")

func calculate_token_reward(product, amount):
    # Calculate token rewards based on product and amount
    # You can customize this based on your game economy
    var base_reward = 1
    
    match product:
        "milk":
            base_reward = 2
        "eggs":
            base_reward = 1
        "meat":
            base_reward = 3
        _:
            base_reward = 1
    
    return base_reward * amount
