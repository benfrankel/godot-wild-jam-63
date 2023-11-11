extends Camera2D
class_name CameraFollowPlayer

@export var target: Node2D

func _ready():
	self.global_position = self.target.global_position

func _process(delta: float):
	# use camera position smoothing instead
	self.global_position = target.global_position
