tool
extends TileSet

func _forward_subtile_selection(autotile_id, bitmask, tilemap, tile_location):
	if autotile_id == 0:
		# Dirt
		var dirt_tiles = [[2, Vector2(0, 0)], [1, Vector2(0, 1)], [2, Vector2(1, 0)], [3, Vector2(1, 1)]]
		var max_dirt_tile_weight = 8.0
		
		var x = randf() * max_dirt_tile_weight
		var total = 0
		for tile in dirt_tiles:
			total += tile[0]
			if x < total:
				return tile[1]
	
	if autotile_id == 2 or autotile_id == 4:
		# Tilled dry or wet
		bitmask &= BIND_LEFT | BIND_RIGHT
		
		if bitmask == BIND_RIGHT:
			return Vector2(0, 0)
		if bitmask == BIND_RIGHT | BIND_LEFT:
			return Vector2(1, 0)
		if bitmask == BIND_LEFT:
			return Vector2(2, 0)
		
		return Vector2(3, 0)
	
	if autotile_id == 5:
		# Grass Path
		bitmask &= BIND_TOP | BIND_LEFT | BIND_RIGHT | BIND_BOTTOM
		
		if bitmask == BIND_TOP | BIND_LEFT | BIND_RIGHT | BIND_BOTTOM:
			return Vector2(0, 0)
		if bitmask == BIND_TOP | BIND_LEFT | BIND_RIGHT:
			return Vector2(1, 0)
		if bitmask == BIND_TOP | BIND_LEFT | BIND_BOTTOM:
			return Vector2(2, 0)
		if bitmask == BIND_TOP | BIND_RIGHT | BIND_BOTTOM:
			return Vector2(3, 0)
		if bitmask == BIND_LEFT | BIND_RIGHT | BIND_BOTTOM:
			return Vector2(0, 1)
		if bitmask == BIND_TOP | BIND_LEFT:
			return Vector2(1, 1)
		if bitmask == BIND_TOP | BIND_RIGHT:
			return Vector2(2, 1)
		if bitmask == BIND_TOP | BIND_BOTTOM:
			return Vector2(3, 1)
		if bitmask == BIND_LEFT | BIND_RIGHT:
			return Vector2(0, 2)
		if bitmask == BIND_LEFT | BIND_BOTTOM:
			return Vector2(1, 2)
		if bitmask == BIND_RIGHT | BIND_BOTTOM:
			return Vector2(2, 2)
		if bitmask == BIND_TOP:
			return Vector2(3, 2)
		if bitmask == BIND_LEFT:
			return Vector2(0, 3)
		if bitmask == BIND_RIGHT:
			return Vector2(1, 3)
		if bitmask == BIND_BOTTOM:
			return Vector2(2, 3)
		
		return Vector2(3, 3)

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in [2, 4]:
		# Tilled dry and wet
		return neighbor_id in [2, 4]
	
	if drawn_id == 1:
		# Grass
		return neighbor_id in [5, 6, 7]
	
	if drawn_id in [3, 7]:
		# Walls
		return neighbor_id in [3, 7, 8]
