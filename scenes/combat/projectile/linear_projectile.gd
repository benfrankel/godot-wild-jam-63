class_name LinearProjectile
extends Projectile


var is_moving := false


func _ready() -> void:
	await get_tree().create_timer(wait).timeout
	is_moving = true


func _physics_process(delta: float):
	if not is_moving:
		return

	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity
