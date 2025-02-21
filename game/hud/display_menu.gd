extends Control

onready var player = Global.current_scene.player

func _on_visibility_changed():
	if is_visible_in_tree():
		$Scroll/Menu/Button.grab_focus()
		$Scroll/Menu/MoneyLabel.text = "Gold: %sG" % player.money
		$Scroll/Menu/TimeLabel.text = "Time: %s" % Global.current_scene.calender.get_time_string()

func _on_Button_pressed():
	owner.get_node("SFXButton").play()
	
	get_parent().get_parent().hide()
	Global.main_scene.set_current_scene(load("res://mainmenu/mainmenu.tscn"))
