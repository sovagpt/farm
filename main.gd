tool
extends Control

export(PackedScene) var STARTUP_SCENE

var is_transitioning = false
var current_scene = null

var base_size = Vector2(64, 64)
var game_scale:int = 1
var game_pos:Vector2

signal fade_in_finished()
signal fade_out_finished()

func _ready():
	set_current_scene(STARTUP_SCENE)

func _input(event):
	event = event.xformed_by(Transform2D(Vector2(1, 0) * game_scale, Vector2(0, 1) * game_scale, game_pos).affine_inverse())
	$Viewport.input(event)

func _unhandled_input(event):
	event = event.xformed_by(Transform2D(Vector2(1, 0) * game_scale, Vector2(0, 1) * game_scale, game_pos).affine_inverse())
	$Viewport.unhandled_input(event)

func set_current_scene(new_scene:PackedScene, call_func=null):
	if is_transitioning or Engine.editor_hint:
		return false
	
	is_transitioning = true
	
	if current_scene:
		fade_in()
		yield(self, "fade_in_finished")
		
		$Viewport.remove_child(current_scene)
		current_scene.free()
	
	current_scene = new_scene.instance()
	$Viewport.add_child(current_scene)
	
	if call_func:
		if current_scene.has_method(call_func):
			current_scene.call_deferred(call_func)
	
	fade_out()

func fade_in():
	is_transitioning = true
	$Viewport/TransitionLayer/Anim.play_backwards("fade_in")
	yield($Viewport/TransitionLayer/Anim, "animation_finished")
	emit_signal("fade_in_finished")

func fade_out():
	$Viewport/TransitionLayer/Anim.play("fade_in")
	yield($Viewport/TransitionLayer/Anim, "animation_finished")
	emit_signal("fade_out_finished")
	is_transitioning = false

func _draw():
	var window_size = rect_size
	var scale_x = max(1, window_size.x / base_size.x)
	var scale_y = max(1, window_size.y / base_size.y)
	game_scale = min(scale_x, scale_y) as int
	
	var size = base_size * game_scale
	game_pos = (window_size * 0.5 - size * 0.5).floor()
	draw_texture_rect($Viewport.get_texture(), Rect2(game_pos, size), false)
