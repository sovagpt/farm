extends "res://game/objects/base_object.gd"

var gave_info = false

func interact(unit):
	if not gave_info:
		gave_info = true
		Global.current_scene.show_message("I take crops to market every day. I'll deliver the gold to you the next morning.")
		yield(Global.current_scene, "message_finished")
	
	if unit.is_in_group("Player"):
		unit.get_node("HUD").open_sell_menu()
