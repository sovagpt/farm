extends Node2D

func _ready():
	set_process(visible)

func _process(delta):
	update()

func _draw():
	for tile in get_parent().tiles.values():
		if tile.object:
			draw_circle(tile.position * 8 + Vector2(4, 4), 4, Color(0, 1, 0, 0.5))
		if tile.unit:
			draw_circle(tile.position * 8 + Vector2(4, 4), 4, Color(1, 0, 0, 0.5))
