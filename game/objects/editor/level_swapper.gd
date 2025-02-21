extends "../base_object.gd"

export var LEVEL_NAME = ""
export var SPAWN_ID = 0

export(int, FLAGS, "Tile Enter", "Interact") var TRIGGER_TYPE = 1

var is_active = false

func _ready():
	call_deferred("set", "is_active", true)

func tile_entered(unit):
	if is_active and TRIGGER_TYPE & 1:
		if unit.is_in_group("Player"):
			Global.current_scene.goto_level(LEVEL_NAME, SPAWN_ID)

func interact(unit):
	if is_active and TRIGGER_TYPE & 2:
		if unit.is_in_group("Player"):
			Global.current_scene.goto_level(LEVEL_NAME, SPAWN_ID)

func do_save():
	var ret = .do_save()
	ret.LEVEL_NAME = LEVEL_NAME
	ret.SPAWN_ID = SPAWN_ID
	ret.TRIGGER_TYPE = TRIGGER_TYPE
	return ret
