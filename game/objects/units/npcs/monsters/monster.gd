extends "../base_ai.gd"

const Monsters = preload("res://data/monsters.gd")

var monster_type = 0 setget set_monster_type

func _ready():
	set_monster_type(randi()%3)

func set_monster_type(n):
	monster_type = n
	$Sprite.texture = Monsters.data[monster_type].texture
	MAX_HEALTH = Monsters.data[monster_type].health
	self.health = MAX_HEALTH
	SPEED = Monsters.data[monster_type].speed

func attack(unit, time=1):
	unit.take_damage(self)
	delay(time)
	
	var e = preload("res://game/effects/monster_attack/monster_attack.tscn").instance()
	e.position = unit.position
	map.add_child(e)

func _on_delay_finished():
	if can_act:
		# Check for attack
		for tile in map.get_tiles_in_range(map_position, 1):
			if tile.unit and tile.unit.is_in_group("PlantNPC"):
				attack(tile.unit)
				break
			elif tile.object and tile.object.is_in_group("Plant"):
				attack(tile.object, 2)
				break
		
		if can_act:
			var desired_move = Vector2()
			for tile in map.get_tiles_in_range(map_position, 4):
				if tile.unit:
					if tile.unit.is_in_group("PlantNPC"):
						desired_move += ai_attract(tile.position)
					elif tile.unit.is_in_group("Player"):
						desired_move += ai_repel(tile.position)
				elif tile.object:
					if tile.object.is_in_group("Plant"):
						desired_move += ai_attract(tile.position)
			
			if desired_move != Vector2():
				move(desired_move)
				delay(0.1)
			else:
				if randi()%100 < 25:
					move(ai_wander())
				else:
					delay(SPEED)
