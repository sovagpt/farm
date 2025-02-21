extends "res://game/objects/base_object.gd"

func tile_entered(unit):
	if unit.is_in_group("Player"):
		yield(unit, "delay_finished")
		
		unit.update_facing(Vector2(0, 1))
		Global.current_scene.next_day()
