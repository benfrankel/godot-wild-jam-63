extends Camera2D
class_name CameraFollowPlayer

@export var target: Node2D

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	global_position = target.global_position
	align()

func _process(_delta: float) -> void:
	# use camera position smoothing instead
	global_position = target.global_position
