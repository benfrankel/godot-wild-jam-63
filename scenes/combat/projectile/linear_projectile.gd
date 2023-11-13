class_name LinearProjectile
extends Projectile


func _physics_process(delta: float):
	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity
