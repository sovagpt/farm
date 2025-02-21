extends "res://game/inventory/inventory.gd"

const ToolItem = preload("res://game/inventory/inventory_items/tools/tool_item.gd")

const MAX_TOOLS = 4

func _init():
	items.resize(MAX_TOOLS + MAX_ITEMS)

func get_active_tool():
	return items[0] if items[0] and items[0] is ToolItem else null

func next_tool():
	for i in MAX_TOOLS - 1:
		swap_items(i, fposmod(i - 1, MAX_TOOLS))

func prev_tool():
	for i in range(MAX_TOOLS - 1, 0, -1):
		swap_items(i, (i + 1) % MAX_TOOLS)
