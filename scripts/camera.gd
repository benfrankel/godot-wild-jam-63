extends Camera2D
class_name CameraFollowPlayer

@export var target: Node2D

func _ready() -> void:
	self.global_position = self.target.global_position

func _process(_delta: float) -> void:
	# use camera position smoothing instead
	self.global_position = target.global_position
