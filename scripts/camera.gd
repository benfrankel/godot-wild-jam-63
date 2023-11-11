extends Camera2D


@export
var follow_rate: Vector2
@export
var target: Node2D


func _ready():
	self.global_position = self.target.global_position


func _process(delta: float):
	var follow := (delta * self.follow_rate).clamp(Vector2.ZERO, Vector2.ONE)
	var displacement := self.target.global_position - self.global_position
	self.global_position += follow * displacement
