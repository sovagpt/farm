extends Button

var item_id = -1
var is_highlighted = false setget set_highlighted

func _ready():
	align = ALIGN_LEFT
#	rect_clip_content = true
	clip_text = true

func set_highlighted(b):
	is_highlighted = b
	update()

func _draw():
	if is_highlighted:
		draw_style_box(get_stylebox("focus"), Rect2(Vector2(), rect_size))
