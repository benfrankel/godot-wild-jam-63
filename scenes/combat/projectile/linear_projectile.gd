class_name LinearProjectile
extends Projectile


@export_range(0.0, 1000.0) var speed := 300.0
@export_range(0.0, TAU) var angle := 0.0


func _physics_process(delta: float):
	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity
