class_name Projectile
extends RigidBody2D


## Time in seconds before the projectile starts moving.
@export var wait_time := 0.2
## Initial speed of the projectile.
@export var speed := 300.0
## Initial angle of the projectile.
@export var angle := 0.0
## Lifetime of the projectile in seconds.
@export var lifetime := 10.0
@onready var hitbox: CollisionShape2D = $Hitbox


func _ready() -> void:
	start_after_wait()
	despawn_after_lifetime()


func despawn_after_lifetime() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func start_after_wait() -> void:
	stop()
	await get_tree().create_timer(wait_time).timeout
	start()


func start() -> void:
	set_physics_process(true)
	hitbox.set_deferred("disabled", false)


func stop() -> void:
	set_physics_process(false)
	hitbox.set_deferred("disabled", true)


func on_hit() -> void:
	pass
