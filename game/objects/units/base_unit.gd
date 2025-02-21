extends "res://game/objects/base_object.gd"

enum Facing {FACE_UP, FACE_RIGHT, FACE_DOWN, FACE_LEFT}

export var SPEED = 0.25
export var NO_FACING = false

var can_act = true
var facing = FACE_DOWN

signal delay_finished()

func move(dir):
	dir = get_move_direction(dir)
	
	var old_position = position
	if map.move_unit(self, dir):
		$SFXFootstep.play()
		# Move
		update_facing(dir)
		
		$Tween.interpolate_property(
				self,
				"position",
				old_position,
				old_position + dir * 8,
				SPEED,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN
		)
		
		$Sprite.frame += 1
		$Tween.interpolate_property(
				$Sprite,
				"frame",
				$Sprite.frame,
				$Sprite.frame - 1,
				SPEED * 0.5,
				Tween.TRANS_LINEAR,
				Tween.EASE_IN,
				SPEED * 0.5
		)
		
		$Tween.start()
		
		delay(SPEED)
		
	else:
		if dir != Vector2():
			# Bump
			update_facing(dir)
			
			$Tween.interpolate_property(
					$Sprite,
					"position",
					Vector2(),
					dir,
					SPEED * 0.25,
					Tween.TRANS_LINEAR,
					Tween.EASE_IN
			)
			$Tween.interpolate_property(
					$Sprite,
					"position",
					dir,
					Vector2(),
					SPEED * 0.25,
					Tween.TRANS_LINEAR,
					Tween.EASE_IN,
					SPEED * 0.25
			)
			
			$Tween.start()
			
			delay(SPEED * 0.5)

func delay(time):
	can_act = false
	
	if $DelayTimer.is_stopped():
		$DelayTimer.start(time + 0.01)
		
	else:
		$DelayTimer.wait_time = $DelayTimer.time_left + time
		$DelayTimer.start()

func get_facing_dir():
	var dir = Vector2(0, -1)
	
	match facing:
		FACE_DOWN:
			dir = -dir
		FACE_LEFT:
			dir = Vector2(dir.y, -dir.x)
		FACE_RIGHT:
			dir = Vector2(-dir.y, dir.x)
	
	return dir

func get_move_direction(vec:Vector2):
	var ang = vec.angle()
	ang = round(ang / (0.5 * PI)) * 0.5 * PI
	return (Vector2(cos(ang), sin(ang)) + Vector2(0.5, 0.5)).floor()

func update_facing(dir):
	if NO_FACING:
		return
	
	match dir:
		Vector2(0, -1):
			facing = FACE_UP
			$Sprite.frame = 4
		Vector2(1, 0):
			facing = FACE_RIGHT
			$Sprite.frame = 2
			$Sprite.scale = Vector2(1, 1)
		Vector2(-1, 0):
			facing = FACE_LEFT
			$Sprite.frame = 2
			$Sprite.scale = Vector2(-1, 1)
		_:
			facing = FACE_DOWN
			$Sprite.frame = 0

func _on_DelayTimer_timeout():
	can_act = true
	emit_signal("delay_finished")

func do_save():
	var ret = .do_save()
	ret.SPEED = SPEED
	ret.NO_FACING = NO_FACING
	return ret
