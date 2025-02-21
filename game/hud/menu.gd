extends Popup

func _unhandled_input(event):
	if is_visible_in_tree():
		if event.is_action_pressed("ui_right"):
			$Tabs.current_tab = fposmod($Tabs.current_tab + 1, $Tabs.get_tab_count())
			get_tree().set_input_as_handled()
		
		if event.is_action_pressed("ui_left"):
			$Tabs.current_tab = fposmod($Tabs.current_tab - 1, $Tabs.get_tab_count())
			get_tree().set_input_as_handled()
		
		if event.is_action_pressed("ui_cancel") or event.is_action_pressed("open_menu"):
			hide()
			get_tree().set_input_as_handled()

func _on_about_to_show():
	get_tree().paused = true

func _on_popup_hide():
	get_tree().paused = false
