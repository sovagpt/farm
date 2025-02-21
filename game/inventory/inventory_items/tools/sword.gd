extends "tool_item.gd"

func _init():
	NAME = "Sword"
	DESCRIPTION = "Use to fight monsters and cut plants."
	TEXTURE = preload("res://sprites/tool1.png")
	POSITIONS = [Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1)] as PoolVector2Array

func _use(target_tiles, map, unit):
	var e = preload("res://game/effects/sword/slash.tscn").instance()
	map.add_child(e)
	e.position = map.map_to_world(target_tiles[1].position) + map.cell_size * 0.5
	e.rotation = unit.get_facing_dir().rotated(PI*0.5).angle()
	
	for tile in target_tiles:
		if tile.unit:
			if tile.unit.has_method("take_damage"):
				tile.unit.take_damage(unit, 1)
		if tile.object:
			if tile.object.has_method("take_damage"):
				tile.object.take_damage(unit, 1)
