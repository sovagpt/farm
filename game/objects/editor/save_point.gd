extends "../base_object.gd"

func interact(unit):
	if unit.is_in_group("Player"):
		Global.current_scene.save_game()
		Global.current_scene.show_message("Game Saved.")
