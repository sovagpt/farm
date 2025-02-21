extends PopupPanel

var is_active = false

var _unpause = true

func _ready():
	pass

func _input(event):
	if event.is_pressed() and not event.is_echo():
		if visible:
			get_tree().set_input_as_handled()
			
			if not is_active:
				_add_lines()
			else:
				$Label.percent_visible = 1

func show_message(message):
	$Label.text = message
	$Label.lines_skipped = 0
	popup()
	
	call_deferred("_add_lines", true)

func _add_lines(start=false):
	is_active = true
	
	var visible_lines = $Label.get_visible_line_count()
	var line_count = $Label.get_line_count()
	
	if not start:
		$Label.lines_skipped += visible_lines
		
		if $Label.lines_skipped >= line_count:
			hide()
	
	$NextIcon.hide()
	$Blink.stop()
	
	if visible:
		var percent_needed = min(visible_lines, line_count - $Label.lines_skipped) / line_count as float
		
		$Label.percent_visible = 0
		while $Label.percent_visible < percent_needed:
			$Label.percent_visible += 0.05 * (visible_lines / line_count as float)
			
			yield(get_tree().create_timer(0.05), "timeout")
		$Label.percent_visible = 1
	
	$NextIcon.show()
	$Blink.start()
	
	is_active = false

func _on_about_to_show():
	_unpause = not get_tree().paused
	if _unpause:
		get_tree().paused = true

func _on_popup_hide():
	if _unpause:
		get_tree().paused = false
	
	owner.emit_signal("message_finished")

func _on_Blink_timeout():
	$NextIcon.visible = not $NextIcon.visible
