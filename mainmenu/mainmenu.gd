extends Control

func _ready():
	MusicPlayer.play()
	
	var file = File.new()
	if file.file_exists(preload("res://game/game.gd").SAVE_PATH):
		$VBoxContainer/ContinueButton.show()
	
	if $VBoxContainer/ContinueButton.visible:
		$VBoxContainer/ContinueButton.grab_focus()
	else:
		$VBoxContainer/NewButton.grab_focus()

func _on_ContinueButton_pressed():
	$SFXButton.play()
	Global.main_scene.set_current_scene(preload("res://game/game.tscn"), "load_game")

func _on_NewButton_pressed():
	$SFXButton.play()
	Global.main_scene.set_current_scene(preload("res://game/game.tscn"), "new_game")

func _on_QuitButton_pressed():
	get_tree().quit()
