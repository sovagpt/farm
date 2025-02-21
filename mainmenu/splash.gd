extends Control

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		goto_main_menu()
	
func goto_main_menu():
	Global.main_scene.set_current_scene(preload("res://mainmenu/mainmenu.tscn"))
