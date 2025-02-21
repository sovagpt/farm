extends "res://game/objects/base_object.gd"

var gave_info = false

var inventory = preload("res://game/inventory/inventory.gd").new()

func _init():
	add_random_seeds()

func next_day():
	add_random_seeds()

func add_random_seeds():
	if inventory.get_item_count() < 10:
		for i in rand_range(5, 10) as int:
			var item = preload("res://game/inventory/inventory_items/tools/seed_tool.gd").new(randi() % 5) #max number of plants
			inventory.add_item(item)

func interact(unit):
	if not gave_info:
		gave_info = true
		Global.current_scene.show_message("Buy seeds here!")
		yield(Global.current_scene, "message_finished")
	
	if unit.is_in_group("Player"):
		unit.get_node("HUD").open_buy_menu(inventory)

func do_save():
	var ret = .do_save()
	ret.__inventory = inventory.do_save()
	return ret

func do_load(data):
	.do_load(data)
	inventory.do_load(data.__inventory)
