class_name LinearProjectile
extends Projectile


## Time to stop moving "in shock" after touching the laser.
@export var shock_time := 0.0


func _physics_process(delta: float):
	if not is_moving:
		return

	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity


func start() -> void:
	super.start()
	$Hitbox.set_deferred("disabled", false)


func stop() -> void:
	super.stop()
	$Hitbox.set_deferred("disabled", true)


func _on_area_entered(area: Area2D) -> void:
	if not area is Laser:
		return

	stop()
	await get_tree().create_timer(shock_time).timeout
	queue_free()
