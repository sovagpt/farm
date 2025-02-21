extends "tool_item.gd"

func _init():
	NAME = "Hoe"
	DESCRIPTION = "Use to till barren land."
	TEXTURE = preload("res://sprites/tool3.png")
	POSITIONS = [Vector2(0, -1), Vector2(0, -2)] as PoolVector2Array

func _use(target_tiles, map, unit):
	for tile in target_tiles:
		if tile.tags & Tile.TAG_TILLABLE and not tile.tags & Tile.TAG_TILLED:
			# Till ground
			tile.tags |= Tile.TAG_TILLED
			map.set_cellv(tile.position, 2)
			map.update_bitmask_area(tile.position)
			
			var e = preload("res://game/effects/tilling/dirt.tscn").instance()
			map.add_child(e)
			e.position = map.map_to_world(tile.position) + map.cell_size * 0.5
