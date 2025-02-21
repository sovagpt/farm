extends Control

const ToolItem = preload("res://game/inventory/inventory_items/tools/tool_item.gd")

var current_tool = null

onready var player = Global.current_scene.player

func _ready():
	player.inventory.connect("items_changed", self, "update_tool")
	player.connect("state_changed", self, "_on_player_state_changed")

func update_tool():
	set_tool(player.inventory.get_active_tool())
	
	for i in $SwapBar.get_child_count():
		var item = player.inventory.items[i + 1]
		var child = $SwapBar.get_child(i)
		
		if not player.current_state is player.StateSwapTool:
			$NameHide.start()
		
		if item and item is ToolItem:
			child.get_node("Label").text = item.NAME
			child.get_node("Icon").texture = item.TEXTURE
		else:
			child.get_node("Label").text = ""
			child.get_node("Icon").texture = preload("res://sprites/empty_item.png")

func set_tool(new_tool):
	if current_tool == new_tool:
		return
	
	if current_tool:
		current_tool.disconnect("update_draw", $ToolDraw, "update")
	
	current_tool = new_tool
	
	if new_tool:
		$Label.text = new_tool.NAME
		$Label.show()
		
		$Icon.texture = new_tool.TEXTURE
		
		new_tool.connect("update_draw", $ToolDraw, "update")
		
	else:
		$Label.text = ""
		$Icon.texture = preload("res://sprites/empty_item.png")
	
	$ToolDraw.update()

func _on_player_state_changed():
	if player.current_state is player.StateSwapTool:
		$SwapBar.show()
		$Label.show()
		$NameHide.stop()
	else:
		$SwapBar.hide()
		if $Label.visible and $NameHide.is_stopped():
			$NameHide.start()
