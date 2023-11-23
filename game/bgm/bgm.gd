extends Node


const SILENCE_VOLUME := -80.0
const QUIET_VOLUME := -20.0

var tween: Tween

@onready var active := $Active as AudioStreamPlayer
@onready var background := $Background as AudioStreamPlayer


func play_stream(audio: AudioStream, duration := 0.5, volume := 0.0) -> void:
	if tween:
		tween.kill()

	# swap
	var temp := background
	background = active
	active = temp

	active.stop()
	active.stream = audio
	active.volume_db = QUIET_VOLUME

	tween = get_tree().create_tween()
	tween.tween_property(background, "volume_db", QUIET_VOLUME, duration / 2.0)
	tween.tween_callback(Callable(active, "play"))
	tween.tween_property(background, "volume_db", SILENCE_VOLUME, duration / 2.0)
	tween.parallel().tween_property(active, "volume_db", volume, duration)
	tween.tween_callback(Callable(background, "stop"))
