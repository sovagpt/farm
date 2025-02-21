extends PopupPanel

var inventory = null

onready var player = Global.current_scene.player

func _ready():
	player.connect("money_changed", self, "_on_money_changed")

func _input(event):
	if is_visible_in_tree():
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("open_menu"):
			hide()
			get_tree().set_input_as_handled()

func _update_items():
	for button in $Box/Scroll/Items.get_children():
		var item = inventory.items[button.item_id]
		
		if item:
			button.text = item.NAME
			if item.count > 1:
				button.text = "%sx %s" % [item.count, item.NAME]
			button.icon = item.TEXTURE
			
		else:
			var index = button.get_index()
			$Box/Scroll/Items.remove_child(button)
			button.queue_free()
			
			if $Box/Scroll/Items.get_child_count() > 0:
				$Box/Scroll/Items.get_child(max(0, index - 1)).grab_focus()
	
	$Box/PriceLabel.visible = $Box/Scroll/Items.get_child_count() > 0

func _on_money_changed():
	$Box/MoneyLabel.text = "Gold: %sG" % player.money

func _on_item_pressed(button):
	owner.get_node("SFXButton").play()
	
	if inventory.items[button.item_id].PRICE <= player.money:
		player.money -= inventory.items[button.item_id].PRICE
		player.inventory.add_item(inventory.remove_item_id(button.item_id), 2)

func _on_item_focus_entered(button):
	$Box/Scroll.scroll_vertical = $Box/Scroll/Items.get_child(max(0, button.get_index() - 1)).rect_position.y
	$Box/PriceLabel.text = "Price: %sG" % inventory.items[button.item_id].PRICE

func _on_about_to_show():
	get_tree().paused = true
	_on_money_changed()
	
	if inventory:
		inventory.connect("items_changed", self, "_update_items")
		for i in inventory.items.size():
			var item = inventory.items[i]
			
			if item and item.PRICE > 0:
				var button = preload("res://game/hud/inventory_button.gd").new()
				button.text = item.NAME
				if item.count > 1:
					button.text = "%sx %s" % [item.count, item.NAME]
				button.icon = item.TEXTURE
				button.item_id = i
				
				button.connect("pressed", self, "_on_item_pressed", [button])
				button.connect("focus_entered", self, "_on_item_focus_entered", [button])
				
				$Box/Scroll/Items.add_child(button)
		
		$Box/PriceLabel.visible = $Box/Scroll/Items.get_child_count() > 0

func _on_popup_hide():
	get_tree().paused = false
	
	for child in $Box/Scroll/Items.get_children():
		child.queue_free()
	
	if inventory:
		inventory.disconnect("items_changed", self, "_update_items")
		inventory = null
