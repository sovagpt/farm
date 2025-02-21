extends Node

const SAVE_PATH = "user://savegame.savegame"

var levels = {}
onready var level_names = $LevelPreloader.get_resource_list()

var player = preload("res://game/objects/units/player/player.tscn").instance()
var calender = preload("res://game/calender.gd").new()
var market = preload("res://game/market.gd").new()
var current_level = null

signal message_finished()

func _ready():
	calender.connect("day_changed", self, "_on_day_changed")
	$ClockTimer.connect("timeout", calender, "tick")
	
	for s in level_names:
		levels[s] = $LevelPreloader.get_resource(s).instance()
	
	call_deferred("goto_level", "house")

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		for level in levels.values():
			if is_instance_valid(level):
				level.queue_free()

func goto_level(new_level_name:String, spawn_id=0):
	assert levels.has(new_level_name)
	
	player.call_deferred("lock_player")
	
	var do_fade = not Global.main_scene.is_transitioning
	
	# Fade in
	if do_fade:
		Global.main_scene.fade_in()
		yield(Global.main_scene, "fade_in_finished")
	
	# Switch level
	if player.is_inside_tree():
		player.map.remove_object(player)
		player.get_parent().remove_child(player)
	
	if current_level:
		$LevelHolder.remove_child(current_level)
	
	current_level = levels[new_level_name]
	$LevelHolder.add_child(current_level)
	
	player.position = current_level.map.get_spawn_position(spawn_id)
	current_level.map.add_object(player)
	
	# Fade out
	if do_fade:
		Global.main_scene.fade_out()
		yield(Global.main_scene, "fade_out_finished")
	
	player.call_deferred("unlock_player")

func has_level(level_name):
	return levels.has(level_name)

func next_day(message="Game Saved."):
	player.lock_player()
	
	Global.main_scene.fade_in()
	yield(Global.main_scene, "fade_in_finished")
	
	calender.next_day()
	save_game()
	show_message(message)
	
	yield(self, "message_finished")
	
	goto_level("house", 1)
	
	Global.main_scene.fade_out()
	yield(Global.main_scene, "fade_out_finished")
	
	player.unlock_player()

func show_message(message:String):
	$UI/Base/Message.show_message(message)

func save_game():
	var data = {
		player = player.do_save(),
		calender = calender.do_save(),
		levels = {}
	}
	
	for level_name in levels:
		data.levels[level_name] = levels[level_name].do_save()
	
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_var(0)
	file.store_var(data)
	file.close()

func load_game():
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		return
	
	file.open(SAVE_PATH, File.READ)
	var version = file.get_var()
	var data = file.get_var()
	file.close()
	
	calender.do_load(data.calender)
	
	if player.is_inside_tree():
		if player.map:
			player.map.remove_object(player)
		
		player.get_parent().remove_child(player)
	
	for level_name in data.levels:
		var level_data = data.levels[level_name]
		levels[level_name].do_load(level_data)
	
	player.do_load(data.player)
	
	goto_level("house", 1)

func new_game():
	goto_level("farm")

func _on_day_changed():
	for level in levels.values():
		level.next_day()
	
	market.next_day()
