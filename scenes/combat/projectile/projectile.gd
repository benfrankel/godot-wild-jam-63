class_name Projectile
extends RigidBody2D


## Duration in seconds of the projectile's spawn animation.
@export var spawn_time := 0.5
## Duration in seconds of the projectile's despawn animation.
@export var despawn_time := 0.5
## Time to freeze in place after hitting the laser.
@export var hit_stop := 0.5
var lifetime := 5.0
var lifetime_timer := Timer.new()
var laser: Laser
var _collision_layer_backup: int
var _linear_velocity_backup: Vector2
var _angular_velocity_backup: float


func _ready() -> void:
	lifetime_timer.timeout.connect(fade_out.bind(despawn_time))
	lifetime_timer.one_shot = true
	add_child(lifetime_timer)
	lifetime_timer.start(lifetime)
	stop()
	await fade_in(spawn_time)
	start()


func start() -> void:
	collision_layer = _collision_layer_backup
	linear_velocity = _linear_velocity_backup
	angular_velocity = _angular_velocity_backup
	freeze = false
	lifetime_timer.paused = false


func stop() -> void:
	_collision_layer_backup = collision_layer
	_linear_velocity_backup = linear_velocity
	_angular_velocity_backup = angular_velocity
	collision_layer = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	set_deferred("freeze", true)
	lifetime_timer.paused = true


func fade_in(duration: float) -> void:
	var target: Color = modulate
	modulate.a = 0
	await create_tween().tween_property(self, "modulate", target, duration).finished


func fade_out(duration: float) -> void:
	var target: Color = modulate
	target.a = 0
	await create_tween().tween_property(self, "modulate", target, duration).finished
	queue_free()


func on_hit() -> void:
	modulate = Color.RED
	stop()
	fade_out(hit_stop)


# Workaround because RigidBody2D doesn't like being scaled
func custom_set_scale(new_scale: Vector2) -> void:
	var scale_ratio: Vector2 = new_scale / scale
	for child in get_children():
		var child_node := child as Node2D
		if child_node:
			child_node.position *= scale_ratio
			child_node.scale *= scale_ratio
