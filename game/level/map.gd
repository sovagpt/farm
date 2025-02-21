extends TileMap

const Tile = preload("res://game/level/tile.gd")

export(PoolIntArray) var WALKABLE_TILES
export(PoolIntArray) var TILLABLE_TILES
export(PoolIntArray) var TILLED_TILES
export(PoolIntArray) var WET_TILES
export(PoolIntArray) var WATER_TILES

var spawn_positions = []
var tiles = {}

func _init():
	call_deferred("_post_init")

func _post_init():
	for pos in get_used_cells():
		var tile = Tile.new(pos)
		
		var type = get_cellv(pos) as int
		
		if type in WALKABLE_TILES:
			tile.tags |= Tile.TAG_WALKABLE
		
		if type in TILLABLE_TILES:
			tile.tags |= Tile.TAG_TILLABLE
		
		if type in TILLED_TILES:
			tile.tags |= Tile.TAG_TILLED
		
		if type in WET_TILES:
			tile.tags |= Tile.TAG_WATERED
		
		if type in WATER_TILES:
			tile.tags |= Tile.TAG_WATER_SOURCE
		
		tiles[pos] = tile
	
	for pos in $Objects.get_used_cells():
		if tiles.has(pos):
			tiles[pos].tags = 0
	
	for obj in $Objects.get_children():
		add_object(obj)
	
	for child in get_children():
		if child is Position2D:
			spawn_positions.append(child.position)

func add_object(obj):
	obj.map = self
	var obj_position = world_to_map(obj.position)
	
	var tile = get_tile(obj_position)
	if tile:
		if obj.is_in_group("Unit"):
			tile.set_unit(obj)
		elif obj.is_in_group("Object"):
			tile.set_object(obj)
		
		if not obj.is_inside_tree() and not $Objects.is_a_parent_of(obj):
			$Objects.add_child(obj)

func remove_object(obj):
	var tile = get_tile(obj.map_position)
	if tile:
		if obj.is_in_group("Unit"):
			tile.remove_unit()
		elif obj.is_in_group("Object"):
			tile.remove_object()

func move_unit(unit, direction):
	var unit_position = world_to_map(unit.position)
	
	if tiles.has(unit_position + direction):
		var target_tile = tiles[unit_position + direction]
		
		if not target_tile.unit and target_tile.tags & Tile.TAG_WALKABLE and (not target_tile.object or target_tile.object and not target_tile.object.blocks_movement):
			if tiles[unit_position].unit == unit:
				tiles[unit_position].remove_unit()
			
			target_tile.set_unit(unit)
			
			return true
	
	return false

func interact(unit, pos):
	if tiles.has(pos):
		var tile = tiles[pos]
		if tile.unit:
			tile.unit.interact(unit)
		if tile.object:
			tile.object.interact(unit)

func next_day():
	for tile in tiles.values():
		if tile.unit:
			tile.unit.next_day()
		if tile.object:
			tile.object.next_day()
		
		if tile.tags & Tile.TAG_WATERED:
			# Unwater tiles
			tile.tags ^= Tile.TAG_WATERED
			set_cellv(tile.position, 2)
			update_bitmask_area(tile.position)
			
		elif tile.tags & Tile.TAG_TILLED and not tile.object:
			if randi() % 100 < 25:
				# Random chance to untill dirt which wasn't watered
				tile.tags ^= Tile.TAG_TILLED
				set_cellv(tile.position, 0)
				update_bitmask_area(tile.position)

func get_spawn_position(spawn_id):
	return spawn_positions[clamp(spawn_id, 0, spawn_positions.size() - 1)]

func get_tile(map_pos):
	if tiles.has(map_pos):
		return tiles[map_pos]
	
	return null

func get_tiles_in_range(map_pos:Vector2, radius:int):
	var offset = Vector2(-radius, -radius)
	var size = radius + radius + 1
	
	var ret = []
	
	for i in size * size:
		var tile_pos = Vector2(i % size, i / size)
		var tile = get_tile(map_pos + tile_pos + offset)
		if tile and map_pos != tile.position and tile.position.distance_squared_to(map_pos) <= radius * radius:
			ret.append(tile)
	
	return ret

func do_save():
	var ret = {
		tiles = [],
		objects = []
	}
	
	for pos in tiles:
		ret.tiles.append(tiles[pos].do_save())
	
	for obj in $Objects.get_children():
		if obj.is_in_group("Player"):
			continue
		
		if obj.is_in_group("Object") or obj.is_in_group("Unit"):
			ret.objects.append(obj.do_save())
	
	return ret

func do_load(data):
	for tile_data in data.tiles:
		var tile = tiles[tile_data.position]
		tile.do_load(tile_data)
		
		if tile.tags & Tile.TAG_TILLED:
			set_cellv(tile.position, 2)
			update_bitmask_area(tile.position)
		
		if tile.tags & Tile.TAG_WATERED:
			set_cellv(tile.position, 4)
			update_bitmask_area(tile.position)
	
	for obj in $Objects.get_children():
		remove_object(obj)
		obj.free()
	
	for obj_data in data.objects:
		var obj = load(obj_data.__filename).instance()
		obj.position = map_to_world(obj_data.map_position) + Vector2(4, 4)
		add_object(obj)
		obj.do_load(obj_data)
