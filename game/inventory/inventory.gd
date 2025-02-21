extends Reference

# First few slots in items are tools
# Index 0 is the active tool

const InventoryItem = preload("res://game/inventory/inventory_items/inventory_item.gd")

const MAX_ITEMS = 12

var items = []

signal items_changed()

func _init():
	items.resize(MAX_ITEMS)

func get_empty_index():
	var ret = -1
	
	for i in items.size():
		if not items[i]:
			ret = i
			break
	
	return ret

func swap_items(index_a, index_b):
	var item_a = items[index_a]
	var item_b = items[index_b]
	
	items[index_b] = item_a
	items[index_a] = item_b
	
	emit_signal("items_changed")

func add_item(new_item, amnt=1):
	# Duplicate item
	new_item = dict2inst(inst2dict(new_item))
	
	var item_index = -1
	
	for i in items.size():
		var item = items[i]
		if item and item.is_equal(new_item):
			item_index = i
			break
	
	if item_index > -1:
		items[item_index].count += amnt
	else:
		item_index = get_empty_index()
		if item_index > -1:
			new_item.count = amnt
			items[item_index] = new_item
			new_item.connect("count_changed", self, "_on_item_count_changed", [new_item])
		else:
			return false
	
	emit_signal("items_changed")
	return true

func remove_item_id(item_id, amnt=1):
	var item = items[item_id]
	
	if item:
		item.count -= amnt
		
		emit_signal("items_changed")
		return item

func get_item_count() -> int:
	var ret:int
	for item in items:
		if item:
			ret += item.count
	
	return ret

func _on_item_count_changed(item):
	if item.count <= 0:
		items[items.find(item)] = null
		emit_signal("items_changed")

func do_save():
	var ret = []
	for item in items:
		var data = null
		if item:
			data = item.do_save()
		
		ret.append(data)
	
	return ret

func do_load(data):
	for i in items.size():
		items[i] = null
		
		if data[i] != null:
			items[i] = load(data[i].__filename).new()
			items[i].do_load(data[i])
			items[i].connect("count_changed", self, "_on_item_count_changed", [items[i]])
	
	emit_signal("items_changed")
