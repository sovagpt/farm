extends Reference

var NAME:String
var DESCRIPTION:String
var TEXTURE:Texture
var PRICE = -1

var count = 1 setget set_count

signal count_changed

func set_count(n):
	count = n
	emit_signal("count_changed")

func is_equal(to):
	return get_script() == to.get_script()

func do_save():
	var ret = {
		__filename = get_script().resource_path,
		count = count
	}
	return ret

func do_load(data):
	# Double underscore means don't set
	for key in data:
		if not key.begins_with("__"):
			set(key, data[key])
