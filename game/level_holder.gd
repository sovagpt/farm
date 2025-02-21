extends Node2D

export(Gradient) var color_cylce

func _ready():
	get_parent().calender.connect("ticked", self, "_on_tick")
	get_parent().calender.connect("day_changed", self, "_on_tick")
	_on_tick()

func _on_tick():
	var day_percent = get_parent().calender.get_day_percent()
	$DayModulate.color = color_cylce.interpolate(day_percent)