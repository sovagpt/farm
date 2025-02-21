extends "inventory_item.gd"

const Plants = preload("res://data/plants.gd")

var plant_type = 0 setget set_plant_type

func _init(type=0):
	set_plant_type(type)

func set_plant_type(type):
	plant_type = type
	
	NAME = "%s" % Plants.data[plant_type].name
	DESCRIPTION = "This crop is worth %sG." % Plants.data[plant_type].price
	TEXTURE = Plants.data[plant_type].icon
	PRICE = Plants.data[plant_type].price

#func get_name():
#	return "%s" % Plants.data[plant_type].name
#
#func get_description():
#	return "This crop is worth %sG." % Plants.data[plant_type].price
#
#func get_texture():
#	return Plants.data[plant_type].icon

func is_equal(to):
	return .is_equal(to) and plant_type == to.plant_type

func do_save():
	var ret = .do_save()
	ret.plant_type = plant_type
	return ret
