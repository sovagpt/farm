extends Node2D

signal harvested(product, amount)

export(String) var animal_type = "cow"
export(String) var display_name = "Cow"
export(Texture) var animal_texture
export(float) var production_time = 120.0  # seconds
export(String) var product = "milk"
export(int) var base_productivity = 1
export(int) var max_happiness = 10
export(int) var max_level = 5

var current_happiness = 7
var current_productivity = 1
var current_level = 1
var production_progress = 0.0
var ready_to_harvest = false
var nft_token_id = ""  # Will store the Solana NFT token ID when minted

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var progress_bar = $ProgressBar
onready var timer = $ProductionTimer
onready var level_label = $LevelLabel

func _ready():
	# Set up the animal's appearance
	if animal_texture:
		sprite.texture = animal_texture
	
	level_label.text = "Lvl " + str(current_level)
	progress_bar.max_value = production_time
	progress_bar.value = 0
	
	# Start production timer
	timer.wait_time = 1.0  # Update progress every second
	timer.start()
	
	# Start with a random animation
	var animations = animation_player.get_animation_list()
	if animations.size() > 0:
		var random_anim = animations[randi() % animations.size()]
		animation_player.play(random_anim)

func _process(delta):
	# Update production progress
	if not ready_to_harvest:
		progress_bar.value = production_progress
	
func _on_ProductionTimer_timeout():
	if not ready_to_harvest:
		# Progress increases based on happiness and productivity
		var progress_rate = (current_productivity * (0.5 + (current_happiness / max_happiness) * 0.5))
		production_progress += progress_rate
		
		# Check if production is complete
		if production_progress >= production_time:
			complete_production()

func complete_production():
	ready_to_harvest = true
	production_progress = production_time
	progress_bar.value = production_time
	progress_bar.modulate = Color(0.2, 1.0, 0.2)  # Green when ready
	
	# Visual indicator
	$ReadyIndicator.visible = true
	
	# Play ready animation if available
	if animation_player.has_animation("ready"):
		animation_player.play("ready")

func harvest():
	if ready_to_harvest:
		# Calculate harvest amount based on level and productivity
		var harvest_amount = base_productivity * current_level * (0.8 + (current_happiness / max_happiness) * 0.4)
		harvest_amount = int(max(1, harvest_amount))
		
		# Reset production
		ready_to_harvest = false
		production_progress = 0
		progress_bar.value = 0
		progress_bar.modulate = Color(1, 1, 1)  # Reset color
		$ReadyIndicator.visible = false
		
		# Play normal animation
		if animation_player.has_animation("idle"):
			animation_player.play("idle")
		
		# Emit signal with product and amount
		emit_signal("harvested", product, harvest_amount)
		
		return harvest_amount
	
	return 0

func feed():
	# Increase happiness when fed
	current_happiness = min(current_happiness + 2, max_happiness)
	
	# Play feeding animation if available
	if animation_player.has_animation("eat"):
		animation_player.play("eat")
		yield(animation_player, "animation_finished")
		animation_player.play("idle")

func pet():
	# Increase happiness slightly when petted
	current_happiness = min(current_happiness + 1, max_happiness)
	
	# Play petting animation if available
	if animation_player.has_animation("happy"):
		animation_player.play("happy")
		yield(animation_player, "animation_finished")
		animation_player.play("idle")

func decrease_happiness():
	# Happiness decreases over time
	current_happiness = max(current_happiness - 1, 0)

func level_up():
	if current_level < max_level:
		current_level += 1
		current_productivity += 1
		level_label.text = "Lvl " + str(current_level)
		
		# Visual effect for level up
		$LevelUpEffect.emitting = true
		
		return true
	return false

func get_nft_attributes():
	# Return attributes to store in the NFT
	return {
		"level": current_level,
		"productivity": current_productivity,
		"happiness": current_happiness,
		"product": product
	}

func set_from_nft_attributes(attributes):
	# Set animal stats from NFT attributes
	if "level" in attributes:
		current_level = attributes.level
		level_label.text = "Lvl " + str(current_level)
	
	if "productivity" in attributes:
		current_productivity = attributes.productivity
	
	if "happiness" in attributes:
		current_happiness = attributes.happiness
	
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			if ready_to_harvest:
				harvest()
			else:
				pet()

# This function would be called after minting the NFT
func set_nft_token_id(token_id):
	nft_token_id = token_id
	# You might want to display this somewhere or use it for verification