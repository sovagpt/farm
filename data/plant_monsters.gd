extends Reference

enum Plants {CABBAGE, CARROT, EGGPLANT, PARSNIP, TOMATO}

const data = {
	CABBAGE : {
		health = 5,
		texture = preload("res://game/objects/units/npcs/plants/cabbage.png")
	},
	CARROT : {
		health = 3,
		texture = preload("res://game/objects/units/npcs/plants/carrot.png")
	},
	EGGPLANT : {
		health = 4,
		texture = preload("res://game/objects/units/npcs/plants/eggplant.png")
	},
	PARSNIP : {
		health = 3,
		texture = preload("res://game/objects/units/npcs/plants/parsnip.png")
	},
	TOMATO : {
		health = 2,
		texture = preload("res://game/objects/units/npcs/plants/tomato.png")
	}
}
