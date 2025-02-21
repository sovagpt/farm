extends "res://game/level/level.gd"

var start_cutscene_played = false

func _ready():
	pass

func _post_ready():
	._post_ready()
	
	if not start_cutscene_played:
		start_cutscene_played = true
		
		var cutscene = StartingCutscene.new(self)
		cutscene.start()

func next_day():
	.next_day()
	
	#Spawn monsters
	var plant_count = 0
	var valid_spawn_tiles = []
	for tile in map.tiles.values():
		if tile.unit and tile.unit.is_in_group("PlantNPC") or tile.object and tile.object.is_in_group("Plant"):
			plant_count += 1
		
		if tile.tags & tile.TAG_WALKABLE and not tile.unit:
			valid_spawn_tiles.append(tile.position)
	
	valid_spawn_tiles.shuffle()
	
	if plant_count > 0:
		var monster_num = plant_count / 8
		
		if valid_spawn_tiles.size() > monster_num:
			for i in monster_num:
				var pos = valid_spawn_tiles.pop_front()
				var monster = preload("res://game/objects/units/npcs/monsters/monster.tscn").instance()
				monster.position = map.map_to_world(pos) + map.cell_size * 0.5
				
				map.add_object(monster)

func do_save():
	var ret = .do_save()
	ret.start_cutscene_played = start_cutscene_played
	return ret

func do_load(data):
	.do_load(data)
	
	start_cutscene_played = data.start_cutscene_played

class StartingCutscene extends "res://game/level/level.gd".CutsceneBase:
	func _init(level).(level):
		var player = level.get_player_path()
		var old_man = NodePath("TileMap/Objects/OldMan")
		
		lock_player()
		
		delay(0.5)
		
		add_move(player, Vector2(0, 1))
		
		delay(0.5)
		
		for i in 3:
			add_move(old_man, Vector2(-1, 0))
			
			delay(0.3)
		
		add_face(player, Vector2(1, 0))
		
		delay(0.5)
		
		add_message("""Hello there.
			You must be the farmer that bought this old farm.
			This is a magical land where interesting crops will grow.
			The town is to the north, your house is to the east, and there is a pond to the south.
			Here are some seeds to get you started. You can sell crops and buy more seeds in the town.""")
		
		for i in 2:
			add_move(old_man, Vector2(-1, 0))
			
			delay(0.3)
			
			add_move(old_man, Vector2(0, -1))
			
			delay(0.3)
		
		add_delete(old_man)
		
		unlock_player()
