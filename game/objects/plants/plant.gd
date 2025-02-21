extends "res://game/objects/base_object.gd"

const Plants = preload("res://data/plants.gd")
const Tile = preload("res://game/level/tile.gd")

const MAX_STAGE = 3
const MAX_DAYS_WITHOUT_WATER = 1

var plant_type = 0
var current_stage = 0 setget set_current_stage
var days_without_water = 0

var health = 4

func _ready():
	self.current_stage = current_stage

func _enter_tree():
	position.y -= 1

func _exit_tree():
	position.y += 1

func destroy():
	map.remove_object(self)
	
	if current_stage >= MAX_STAGE:
		var unit = preload("res://game/objects/units/npcs/plants/plant_monster.tscn").instance()
		unit.plant_type = plant_type
		unit.position = position
		
		map.add_object(unit)
	
	queue_free()

func interact(unit):
	if unit.is_in_group("Player"):
		if current_stage >= MAX_STAGE:
			destroy()

func take_damage(unit, amnt=1):
	$SFXHurt.play()
	
	if current_stage >= MAX_STAGE:
		destroy()
		
	else:
		health -= amnt
		if health <= 0:
			destroy()

func next_day():
	if map.tiles[map_position].tags & Tile.TAG_WATERED:
		self.current_stage += 1
		
	else:
		if days_without_water >= MAX_DAYS_WITHOUT_WATER:
			destroy()
		
		days_without_water += 1

func set_current_stage(n):
	current_stage = clamp(n, 0, MAX_STAGE)
	
	if current_stage == 0:
		$Sprite.texture = preload("res://game/objects/plants/seed.png")
		$Sprite.hframes = 1
		$Sprite.frame = 0
	else:
		$Sprite.texture = Plants.data[plant_type].texture
		$Sprite.hframes = 3
		$Sprite.frame = (current_stage - 1)

func do_save():
	var ret = .do_save()
	ret.plant_type = plant_type
	ret.current_stage = current_stage
	ret.days_without_water = days_without_water
	return ret
