extends CanvasLayer

func open_menu():
	$Base/Menu.popup()

func open_sell_menu():
	$Base/SellMenu.popup()

func open_buy_menu(inventory):
	$Base/BuyMenu.inventory = inventory
	$Base/BuyMenu.popup()

func hide():
	$Base.hide()

func show():
	$Base.show()
