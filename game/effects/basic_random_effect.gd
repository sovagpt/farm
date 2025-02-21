extends Node2D

export var MAX_DELAY = 0.1

func _ready():
	$Sprite.hide()
	scale.x = -1 if randi() % 2 == 1 else 1
	yield(get_tree().create_timer(randf() * MAX_DELAY),"timeout")
	$Sprite.show()
	$AnimationPlayer.play("start")
