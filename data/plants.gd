extends Reference

enum Plants {CABBAGE, CARROT, EGGPLANT, PARSNIP, TOMATO}

const data = {
	CABBAGE : {
		name = "Cabbage",
		price = 130,
		icon = preload("res://sprites/plants/cabbage.png"),
		texture = preload("res://game/objects/plants/cabbage.png")
	},
	CARROT : {
		name = "Carrot",
		price = 145,
		icon = preload("res://sprites/plants/carrot.png"),
		texture = preload("res://game/objects/plants/carrot.png")
	},
	EGGPLANT : {
		name = "Eggplant",
		price = 195,
		icon = preload("res://sprites/plants/eggplant.png"),
		texture = preload("res://game/objects/plants/eggplant.png")
	},
	PARSNIP : {
		name = "Parsnip",
		price = 105,
		icon = preload("res://sprites/plants/parsnip.png"),
		texture = preload("res://game/objects/plants/parsnip.png")
	},
	TOMATO : {
		name = "Tomato",
		price = 245,
		icon = preload("res://sprites/plants/tomato.png"),
		texture = preload("res://game/objects/plants/tomato.png")
	}
}

static func get_seed_price(num) -> int:
	return floor(num * 0.66667 * 0.2) as int * 5
