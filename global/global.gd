extends Node

var main_scene = null setget ,get_main_scene
var current_scene = null setget ,get_current_scene

func get_main_scene():
	return get_tree().current_scene

func get_current_scene():
	return get_tree().current_scene.current_scene
