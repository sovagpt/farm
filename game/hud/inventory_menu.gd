extends Control

onready var player = Global.current_scene.player
onready var menu = get_parent().get_parent()

var selected_button = null

func _ready():
	call_deferred("_post_ready")

func _post_ready():
	player.inventory.connect("items_changed", self, "_on_items_changed")
	
	for i in player.inventory.items.size():
		var button = preload("res://game/hud/inventory_button.gd").new()
		var item = player.inventory.items[i]
		
		button.item_id = i
		
		if item:
			button.text = item.NAME
			button.icon = item.TEXTURE
		else:
			button.icon = preload("res://sprites/empty_item.png")
		
		button.connect("pressed", self, "_on_item_pressed", [button])
		button.connect("focus_entered", self, "_on_item_focus_entered", [button])
		
		$Scroll/Items.add_child(button)
		
		# Move buttons around label nodes
		if i < player.inventory.MAX_TOOLS:
			$Scroll/Items.move_child(button, i + 1)

func _input(event):
	if is_visible_in_tree():
		if event.is_action_pressed("ui_cancel"):
			if selected_button:
				selected_button.is_highlighted = false
				selected_button = null
				get_tree().set_input_as_handled()
		
		if event.is_action_pressed("menu_inspect"):
			var focus = get_focus_owner()
			if $Scroll/Items.is_a_parent_of(focus):
				var id = focus.item_id
#				id -= 1
#				if id > player.inventory.MAX_TOOLS:
#					id -= 1
				
				if player.inventory.items[id]:
					get_tree().set_input_as_handled()
					var item = player.inventory.items[id]
					
					var text = "%s:\n%s"
					if item.count > 1:
						text = "%ss x%s:\n%s" % [item.NAME, item.count, item.DESCRIPTION]
					else:
						text = text % [item.NAME, item.DESCRIPTION]
					
					Global.current_scene.show_message(text)

func get_item_button(id):
	# Get item button corrected for label nodes
	id += 1
	
	if id > player.inventory.MAX_TOOLS:
		id += 1
	
	return $Scroll/Items.get_child(id)

func _on_item_pressed(button):
	owner.get_node("SFXButton").play()
	
	if selected_button:
		selected_button.is_highlighted = false
		
		player.inventory.swap_items(button.item_id, selected_button.item_id)
		selected_button = null
		
	else:
		selected_button = button
		button.is_highlighted = true

func _on_item_focus_entered(button):
	$Scroll.scroll_vertical = $Scroll/Items.get_child(button.get_index() - 1).rect_position.y

func _on_items_changed():
	for i in player.inventory.items.size():
		var button = get_item_button(i)
		var item = player.inventory.items[i]
		
		if item:
			button.text = item.NAME
			button.icon = item.TEXTURE
		else:
			button.text = ""
			button.icon = preload("res://sprites/empty_item.png")

func _on_visibility_changed():
	if is_visible_in_tree():
		get_item_button(0).grab_focus()
		
	else:
		if selected_button:
			selected_button.is_highlighted = false
			selected_button = null
