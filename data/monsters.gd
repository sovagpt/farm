extends Node

enum Monsters {SLIME, RED_SLIME, MUSHROOM}

const data = {
	SLIME : {
		texture = preload("res://game/objects/units/npcs/monsters/slime.png"),
		speed = 0.5,
		health = 3
	},
	RED_SLIME : {
		texture = preload("res://game/objects/units/npcs/monsters/slime_red.png"),
		speed = 0.35,
		health = 4
	},
	MUSHROOM : {
		texture = preload("res://game/objects/units/npcs/monsters/mushroom.png"),
		speed = 0.3,
		health = 6
	},
}
