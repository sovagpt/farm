extends "../inventory_item.gd"

const Tile = preload("res://game/level/tile.gd")

var POSITIONS:PoolVector2Array

signal update_draw()

func use(unit):
	var positions = get_positions(unit)
	
	var target_tiles = []
	for pos in positions:
		var tile = unit.map.get_tile(unit.map_position + pos)
		if tile:
			target_tiles.append(tile)
	
	_use(target_tiles, unit.map, unit)

func _use(target_tiles, map, unit):
	pass

func get_positions(unit) -> PoolVector2Array:
	var ret = POSITIONS
	
	for i in ret.size():
		var dir = ret[i]
		match unit.facing:
			unit.FACE_DOWN:
				ret[i] = -dir
			unit.FACE_LEFT:
				ret[i] = Vector2(dir.y, -dir.x)
			unit.FACE_RIGHT:
				ret[i] = Vector2(-dir.y, dir.x)
	
	return ret

func _draw(control:Control):
	pass
