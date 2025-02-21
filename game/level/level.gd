extends Node2D

var map

func _init():
	call_deferred("_post_init")

func _post_init():
	map = $TileMap

func _enter_tree():
	request_ready()

func _ready():
	call_deferred("_post_ready")

func _post_ready():
	var used_rect = map.get_used_rect()
	used_rect = used_rect.grow(-1)
	
	var visible_rect = Rect2()
	visible_rect.position = map.map_to_world(used_rect.position, true)
	visible_rect.size = map.map_to_world(used_rect.size, true)
	
	var cam = Global.current_scene.player.get_node("Camera2D")
	cam.limit_left = visible_rect.position.x
	cam.limit_top = visible_rect.position.y
	cam.limit_right = visible_rect.size.x + visible_rect.position.x
	cam.limit_bottom = visible_rect.size.y + visible_rect.position.y

func next_day():
	map.next_day()

func get_player_path():
	return Global.current_scene.player.get_path()

func unit_move(unit_path:NodePath, dir:Vector2):
	var unit = get_node(unit_path)
	unit.move(dir)

func unit_face(unit_path:NodePath, dir:Vector2):
	var unit = get_node(unit_path)
	unit.update_facing(dir)

func delete_object(path:NodePath):
	var obj = get_node(path)
	$TileMap.remove_object(obj)
	obj.free()

func show_message(message:String):
	Global.current_scene.show_message(message)

func lock_player():
	Global.current_scene.player.call_deferred("lock_player")

func unlock_player():
	Global.current_scene.player.unlock_player()

func get_map():
	return map

func do_save():
	var ret = {
		map = $TileMap.do_save()
	}
	return ret

func do_load(data):
	$TileMap.do_load(data.map)

class CutsceneBase extends Reference:
	var level
	
	enum TYPE {TYPE_MOVE, TYPE_FACE, TYPE_DELETE, TYPE_MESSAGE, TYPE_LOCKPLAYER, TYPE_UNLOCKPLAYER, TYPE_DELAY}
	
	var scene = []
	
	func _init(level):
		self.level = level
	
	func start():
		for data in scene:
			match data.key:
				TYPE_MOVE:
					level.unit_move(data.path, data.dir)
				TYPE_FACE:
					level.unit_face(data.path, data.dir)
				TYPE_DELETE:
					level.delete_object(data.path)
				TYPE_MESSAGE:
					level.show_message(data.message)
					yield(Global.current_scene, "message_finished")
				TYPE_LOCKPLAYER:
					level.lock_player()
				TYPE_UNLOCKPLAYER:
					level.unlock_player()
				TYPE_DELAY:
					yield(level.get_tree().create_timer(data.time), "timeout")
	
	func add_key(key):
		scene.append(key)
	
	func add_move(path, dir):
		add_key({
			key = TYPE_MOVE,
			path = path,
			dir = dir
		})
	
	func add_face(path, dir):
		add_key({
			key = TYPE_FACE,
			path = path,
			dir = dir
		})
	
	func add_delete(path):
		add_key({
			key = TYPE_DELETE,
			path = path
		})
	
	func add_message(message):
		add_key({
			key = TYPE_MESSAGE,
			message = message
		})
	
	func lock_player():
		add_key({key = TYPE_LOCKPLAYER})
		
	func unlock_player():
		add_key({key = TYPE_UNLOCKPLAYER})
	
	func delay(time):
		add_key({
			key = TYPE_DELAY,
			time = time
		})
