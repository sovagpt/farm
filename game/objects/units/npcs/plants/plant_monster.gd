extends "../base_ai.gd"

const PlantMonsters = preload("res://data/plant_monsters.gd")

var plant_type = 0 setget set_plant_type

var is_alert = false

func _ready():
	self.plant_type = plant_type

func poof():
	var item = preload("res://game/inventory/inventory_items/plant_item.gd").new(plant_type)
	
	var e = preload("res://game/effects/catch_poof/poof.tscn").instance()
	e.position = position
	map.add_child(e)
	
	map.remove_object(self)
	queue_free()
	
	return item

func set_plant_type(new_type):
	plant_type = new_type
	
	MAX_HEALTH = PlantMonsters.data[plant_type].health
	health = MAX_HEALTH
	$Sprite.texture = PlantMonsters.data[plant_type].texture

func _on_delay_finished():
	# AI logic
	if can_act:
		var has_enemy = false
		var desired_move = Vector2()
		for tile in map.get_tiles_in_range(map_position, 3):
			if tile.unit:
				desired_move += ai_repel(tile.position)
				if not tile.unit.is_in_group("PlantNPC"):
					has_enemy = true
		
		if has_enemy:
			if is_alert:
				move(desired_move)
				delay(0.1)
			else:
				is_alert = true
				delay(SPEED)
		else:
			is_alert = false
			
			if randi()%100 < 25:
				move(ai_wander())
			else:
				delay(SPEED)

func do_save():
	var ret = .do_save()
	ret.plant_type = plant_type
	return ret
