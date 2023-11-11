extends CharacterBody2D


@export_range(0.0, 1000.0)
var speed := 300.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	self.velocity = self.speed * direction
	move_and_slide()
