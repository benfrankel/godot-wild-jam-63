extends Node

@onready var active := $A
@onready var background := $B

var tween : Tween

const PLAYING_VOLUME := 0.0
const SILENCE_VOLUME := -80.0

func play_stream(audio : AudioStream, duration :float = 0.5) -> void:
	background.stop()
	background.stream = audio
	if tween:
		tween.kill()
	# swap
	var temp := background
	background = active
	active = temp

	active.play(0)
	tween = get_tree().create_tween()
	tween.tween_property(active, "volume_db", PLAYING_VOLUME, duration)
	tween.parallel().tween_property(background, "volume_db", SILENCE_VOLUME, duration)
	tween.tween_callback(Callable(background, "stop"))
	
