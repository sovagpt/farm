extends "tool_item.gd"

const Plants = preload("res://data/plants.gd")

const plant_scene = preload("res://game/objects/plants/plant.tscn")

var plant_type = 0 setget set_plant_type

func _init(type=0):
	set_plant_type(type)
	TEXTURE = preload("res://sprites/tool5.png")
	POSITIONS = [Vector2(0, -1)] as PoolVector2Array

func _use(target_tiles, map, unit):
	unit.get_node("SFXPlantSeed").play()
	
	for tile in target_tiles:
		if not tile.object:
			if tile.tags & tile.TAG_TILLED:
				self.count -= 1
				
				var plant = plant_scene.instance()
				plant.plant_type = plant_type
				plant.position = map.map_to_world(tile.position) + map.cell_size * 0.5
				map.add_object(plant)

func set_plant_type(type):
	plant_type = type
	NAME = "%s Seed" % Plants.data[plant_type].name
	DESCRIPTION = "Use these seeds to plant %ss." % Plants.data[plant_type].name.to_lower()
	PRICE = Plants.get_seed_price(Plants.data[plant_type].price)

func is_equal(to):
	return .is_equal(to) and plant_type == to.plant_type

func do_save():
	var ret = .do_save()
	ret.plant_type = plant_type
	return ret
