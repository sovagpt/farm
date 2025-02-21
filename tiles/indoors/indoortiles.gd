tool
extends TileSet

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id == 0:
		# Walls
		return neighbor_id == 7
