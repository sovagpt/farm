extends Node

var is_fading = false

func _ready():
	set_process(false)
	play()

func play():
	is_fading = false
	set_process(false)
	$MusicStream.volume_db = 0
	
	if not $MusicStream.playing:
		$MusicStream.play()

func fade_out():
	if is_fading:
		return
	is_fading = true
	set_process(true)

func _process(delta):
	$MusicStream.volume_db = linear2db(db2linear($MusicStream.volume_db) - delta / 10.0)
	if $MusicStream.volume_db < -50:
		$MusicStream.stop()
		set_process(false)
		is_fading = false