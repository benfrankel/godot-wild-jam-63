class_name Projectile
extends Area2D


## Time in seconds before the projectile starts moving.
@export var wait := 0.0
## Initial speed of the projectile.
@export var speed := 300.0
## Initial angle of the projectile.
@export var angle := 0.0
## Lifetime of the projectile in seconds.
@export var lifetime := 10.0
var is_moving := false


func _ready() -> void:
	start_moving_after_wait()
	despawn_after_lifetime()


func despawn_after_lifetime() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func start_moving_after_wait() -> void:
	stop()
	await get_tree().create_timer(wait).timeout
	start()


func start() -> void:
	is_moving = true


func stop() -> void:
	is_moving = false
