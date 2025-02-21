extends "res://game/objects/units/base_unit.gd"

var MAX_HEALTH = 3
onready var health = MAX_HEALTH

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	connect("delay_finished", self, "_on_delay_finished")
	delay(randf())

func take_damage(unit, amnt=1):
	health -= amnt
	if health <= 0:
		var e = preload("res://game/effects/explosion/explosion.tscn").instance()
		e.position = position
		map.add_child(e)
		
		map.remove_object(self)
		queue_free()
		
	else:
		$AnimationPlayer.play("damaged")
		$SFXHurt.play()
		delay(0.5)

func ai_repel(pos):
	return (map_position - pos).normalized()

func ai_attract(pos):
	return (pos - map_position).normalized()

func ai_wander():
	return Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()

func _on_delay_finished():
	pass
