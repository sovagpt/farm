extends Reference

enum Tags {
	TAG_WALKABLE = 1,
	TAG_TILLABLE = 2,
	TAG_TILLED = 4,
	TAG_WATERED = 8,
	TAG_WATER_SOURCE = 16
}

var position:Vector2

var tags = 0
var unit = null setget set_unit, get_unit
var object = null setget set_object, get_object

func _init(position):
	self.position = position

func remove_unit():
	if self.unit: 
		if self.object:
			object.tile_exited(self.unit)
		
#		unit.tile_exited(unit)
	
	set_unit(null)

func set_unit(new_unit):
	unit = new_unit
	
	if self.unit:
		unit.map_position = position
#		unit.tile_entered(unit)
		
		if self.object:
			object.tile_entered(self.unit)

func get_unit():
	if is_instance_valid(unit):
		return unit
	
	return null

func remove_object():
	set_object(null)

func set_object(new_object):
	object = new_object
	
	if object:
		object.map_position = position

func get_object():
	if is_instance_valid(object):
		return object
	
	return null

func do_save() -> Dictionary:
	var ret = {
		tags = tags,
		position = position
	}
	return ret

func do_load(data):
	for key in data:
		set(key, data[key])
