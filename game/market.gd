extends Reference

var money = 0

func sell_item(item):
	if item.PRICE > 0:
		money += item.PRICE

func next_day():
	Global.current_scene.player.money += money
	money = 0
