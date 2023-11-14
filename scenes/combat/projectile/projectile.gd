class_name Projectile
extends RigidBody2D


## Time in seconds before the projectile starts moving.
@export var wait_time := 0.2
## Lifetime of the projectile in seconds.
@export var lifetime := 10.0
## Time to freeze in place after hitting the laser.
@export var hit_stop := 0.3
## Initial speed of the projectile.
var speed := 300.0
## Initial angle of the projectile.
var angle := 0.0


func _ready() -> void:
	start_after_wait()
	despawn_after_lifetime()


func _physics_process(delta: float) -> void:
	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	move_and_collide(delta * velocity)


func despawn_after_lifetime() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func start_after_wait() -> void:
	stop()
	await get_tree().create_timer(wait_time).timeout
	start()


func start() -> void:
	process_mode = PROCESS_MODE_INHERIT


func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED


func on_hit() -> void:
	stop()
	await get_tree().create_timer(hit_stop).timeout
	queue_free()
