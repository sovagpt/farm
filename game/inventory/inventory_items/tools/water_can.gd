extends "tool_item.gd"

const WATER_MAX = 28
var water_value = WATER_MAX setget set_water_value

func _init():
	NAME = "Water Can"
	DESCRIPTION = "Use to water tilled land and plants. Use on a pond to refill the water."
	TEXTURE = preload("res://sprites/tool2.png")
	POSITIONS = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, -2), Vector2(0, -2), Vector2(1, -2),
		Vector2(-1, -3), Vector2(0, -3), Vector2(1, -3)
	] as PoolVector2Array

func _use(target_tiles, map, unit):
	var use_water = true
	
	unit.get_node("SFXWater").play()
	
	for tile in target_tiles:
		if tile.tags & Tile.TAG_TILLED and not tile.tags & Tile.TAG_WATERED and water_value > 0:
			# Water tilled ground
			tile.tags |= Tile.TAG_WATERED
			map.set_cellv(tile.position, 4)
			map.update_bitmask_area(tile.position)
		
		if tile.tags & Tile.TAG_WATER_SOURCE:
			self.water_value = WATER_MAX
			use_water = false
		
		if water_value > 0:
			var e = preload("res://game/effects/watering/water.tscn").instance()
			map.add_child(e)
			e.position = map.map_to_world(tile.position) + map.cell_size * 0.5
	
	if use_water:
		self.water_value -= 1

func _draw(control):
	control.draw_rect(Rect2(Vector2(), control.rect_size - Vector2(4, 0)), Color("23213d"))
	
	var fill_rect = Rect2(Vector2(1, 1), control.rect_size - Vector2(6, 2))
	fill_rect.position.y += fill_rect.size.y
	fill_rect.position.y -= fill_rect.size.y * water_value / WATER_MAX as float
	fill_rect.size.y *= water_value / WATER_MAX as float
	
	control.draw_rect(fill_rect, Color("4884d4"))

func set_water_value(n):
	water_value = clamp(n, 0, WATER_MAX)
	emit_signal("update_draw")

func do_save():
	var ret = .do_save()
	ret.water_value = water_value
	
	return ret
