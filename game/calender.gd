extends Reference

const MINUTES_IN_DAY = 1440
const WAKE_TIME = 360
const FAINT_TIME = 360

var day = 0
var time = WAKE_TIME + 90

var fainted = false

signal day_changed()
signal ticked()

var TEST_START = OS.get_ticks_msec()

func next_day():
	day += 1
	time = WAKE_TIME
	if fainted:
		time += FAINT_TIME
		fainted = false
	emit_signal("day_changed")
	
	MusicPlayer.play()

func tick():
	time += 1
	if time == int(MINUTES_IN_DAY * 0.8):
		MusicPlayer.fade_out()
	
	if time == MINUTES_IN_DAY:
		fainted = true
		Global.current_scene.next_day("You passed out...")
	else:
		emit_signal("ticked")

func get_day_percent() -> float:
	return float(time % MINUTES_IN_DAY) / MINUTES_IN_DAY

func get_time_string() -> String:
	var ret = "%02d:%02d" % [time / 60, time % 60]
	return ret

func do_save():
	var ret = {
		day = day,
		time = time
	}
	return ret

func do_load(data):
	day = data.day
	time = data.time
