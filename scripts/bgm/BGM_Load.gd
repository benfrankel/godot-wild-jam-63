extends Node
class_name BGM_Load

@export var music : AudioStream
@export var crossfade := 0.5
@export var volume := 0.0
@export var reset_on_end := false

func _ready() -> void:
	if BGM.active.stream != music:
		BGM.play_stream(music, crossfade, volume)

func _exit_tree() -> void:
	if reset_on_end:
		BGM.play_stream(BGM.background.stream, crossfade, volume)
