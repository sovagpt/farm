extends "tool_item.gd"

func _init():
	NAME = "Net"
	DESCRIPTION = "Use to catch harvested plants."
	TEXTURE = preload("res://sprites/tool4.png")
	POSITIONS = [Vector2(0, -1), Vector2(0, -2)] as PoolVector2Array

func _use(target_tiles, map, unit):
	var e = preload("res://game/effects/net_swing/net_swing.tscn").instance()
	map.add_child(e)
	e.position = map.map_to_world(target_tiles[0].position) + map.cell_size * 0.5
	e.rotation = unit.get_facing_dir().rotated(PI*0.5).angle()
	
	for tile in target_tiles:
		if tile.unit and tile.unit.has_method("poof"):
			var item = tile.unit.poof()
			unit.inventory.add_item(item)
