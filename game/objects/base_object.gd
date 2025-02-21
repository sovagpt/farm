extends Node2D

export var blocks_movement = false

var map
var map_position:Vector2

func _enter_tree():
	position = map.map_to_world(map_position) + map.cell_size * 0.5

func interact(unit):
	pass

func tile_entered(unit):
	pass

func tile_exited(unit):
	pass

func next_day():
	pass

func do_save() -> Dictionary:
	var ret = {
		__filename = filename,
		blocks_movement = blocks_movement,
		map_position = map_position
	}
	return ret

func do_load(data):
	# Double underscore means don't set
	for key in data:
		if not key.begins_with("__"):
			set(key, data[key])
