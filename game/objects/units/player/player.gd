extends "../base_unit.gd"

export(StyleBoxFlat) var draw_box

var inventory = preload("res://game/inventory/player_inventory.gd").new()

const MAX_ENERGY = 100

var energy = MAX_ENERGY setget set_energy
var money = 100 setget set_money

var current_state = null

var is_locked = false

signal state_changed()
signal energy_changed()
signal money_changed()

func _init():
	set_state(StateMoving)
	
	for item in [
		preload("res://game/inventory/inventory_items/tools/sword.gd").new(),
		preload("res://game/inventory/inventory_items/tools/hoe.gd").new(),
		preload("res://game/inventory/inventory_items/tools/water_can.gd").new(),
		preload("res://game/inventory/inventory_items/tools/net.gd").new()
		]:
		inventory.add_item(item)
	
	inventory.add_item(preload("res://game/inventory/inventory_items/tools/seed_tool.gd").new(3), 9)

func _ready():
	inventory.emit_signal("items_changed")

func _unhandled_input(event):
	if not event.is_echo() and not is_locked:
		current_state._input(event)

func _process(delta):
	if can_act and not is_locked:
		current_state._process(delta)

func _draw():
	if not is_locked:
		current_state._draw()

func get_dir():
	var dir = Vector2()
	
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	elif Input.is_action_pressed("move_down"):
		dir.y += 1
	elif Input.is_action_pressed("move_left"):
		dir.x -= 1
	elif Input.is_action_pressed("move_right"):
		dir.x += 1
	
	return dir

func set_state(new_state):
	if current_state:
		current_state._exit()
	
	if new_state:
		current_state = new_state.new(self)
		emit_signal("state_changed")

func set_energy(n):
	var last_energy = energy
	energy = clamp(n, 0, MAX_ENERGY) as int
	
	if last_energy != energy:
		if energy%10 == 0 and energy < MAX_ENERGY:
			$AnimationPlayer.play("sweat")
		
		if energy == 10:
			$Sprite.texture = preload("res://game/objects/units/player/player_blue.png")
		
		if energy == 0:
			yield(self, "delay_finished")
			update_facing(Vector2(0, 1))
			Global.current_scene.calender.fainted = true
			Global.current_scene.next_day("You fainted...")
		
		emit_signal("energy_changed")

func set_money(n):
	money = n
	emit_signal("money_changed")

func next_day():
	self.energy = 100
	$Sprite.texture = preload("res://game/objects/units/player/player.png")

func lock_player():
	set_state(StateMoving)
	is_locked = true
	$HUD.hide()

func unlock_player():
	set_state(StateMoving)
	is_locked = false
	$HUD.show()
	inventory.emit_signal("items_changed")

func do_save():
	var ret = .do_save()
	ret.__inventory = inventory.do_save()
	ret.money = money
	
	return ret

func do_load(data):
	.do_load(data)
	
	inventory.do_load(data.__inventory)

class StateBase extends Reference:
	var owner
	
	func _init(owner):
		self.owner = owner
		owner.update()
	
	func _exit():
		pass
	
	func _input(event:InputEvent):
		if event.is_action_pressed("open_menu"):
			owner.get_node("HUD").open_menu()
	
	func _process(delta):
		pass
	
	func _draw():
		pass

class StateMoving extends StateBase:
	func _init(owner).(owner):
		pass
	
	func _input(event:InputEvent):
		._input(event)
		
		if event.is_action_pressed("use_tool"):
			if owner.inventory.get_active_tool():
				owner.set_state(StateReadyTool)
		
		if event.is_action_pressed("swap_tools"):
			owner.set_state(StateSwapTool)
		
		if event.is_action_pressed("interact"):
			owner.set_state(StateInteract)
	
	func _process(delta):
		var dir = owner.get_dir()
		
		if dir != Vector2():
			owner.move(dir)

class StateReadyTool extends StateBase:
	var cancel = false
	
	func _init(owner).(owner):
		pass
	
	func _exit():
		if cancel:
			return
		
		if owner.can_act:
			owner.energy -= 1
			owner.inventory.get_active_tool().use(owner)
			owner.delay(owner.SPEED * 0.25)
	
	func _input(event:InputEvent):
		if event.is_action_released("use_tool"):
			owner.set_state(StateMoving)
		
		if event.is_action_pressed("cancel_tool"):
			cancel = true
			owner.set_state(StateMoving)
	
	func _process(delta):
		var dir = owner.get_dir()
		
		if dir != Vector2():
			owner.update_facing(dir)
		
		owner.update()
	
	func _draw():
		if owner.can_act:
			var positions = owner.inventory.get_active_tool().get_positions(owner)
			
			for pos in positions:
				var rect = Rect2(pos * 8 - Vector2(4, 4), Vector2(8, 8))
				owner.draw_style_box(owner.draw_box, rect)

class StateInteract extends StateBase:
	func _init(owner).(owner):
		pass
	
	func _exit():
		if owner.can_act:
			var dir = owner.get_facing_dir()
			owner.map.interact(owner, owner.map_position + dir)
			owner.delay(owner.SPEED * 0.25)
	
	func _input(event:InputEvent):
		if event.is_action_released("interact"):
			owner.set_state(StateMoving)
	
	func _process(delta):
		var dir = owner.get_dir()
		
		if dir != Vector2():
			owner.update_facing(dir)
			owner.update()
	
	func _draw():
		var dir = owner.get_facing_dir()
		
		var rect = Rect2(dir * 8 - Vector2(4, 4), Vector2(8, 8))
		owner.draw_style_box(owner.draw_box, rect)

class StateSwapTool extends StateBase:
	func _init(owner).(owner):
		pass
	
	func _input(event:InputEvent):
		if event.is_action_pressed("ui_down"):
			owner.inventory.next_tool()
		if event.is_action_pressed("ui_up"):
			owner.inventory.prev_tool()
		
		if event.is_action_released("swap_tools"):
			owner.set_state(StateMoving)

