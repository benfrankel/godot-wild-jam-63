class_name LinearProjectile
extends Projectile


## Time to stop moving "in shock" after touching the laser.
@export var shock_time := 0.0


func _physics_process(delta: float):
	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity


func on_hit() -> void:
	stop()
	await get_tree().create_timer(shock_time).timeout
	queue_free()
