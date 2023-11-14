class_name Projectile
extends RigidBody2D


## Duration in seconds of the projectile's spawn animation.
@export var spawn_time := 0.5
## Duration in seconds of the projectile's despawn animation.
@export var despawn_time := 0.5
## Time to freeze in place after hitting the laser.
@export var hit_stop := 0.5
var lifetime: float
var lifetime_timer := Timer.new()


func _ready() -> void:
	lifetime_timer.timeout.connect(fade_out.bind(despawn_time))
	lifetime_timer.one_shot = true
	add_child(lifetime_timer)
	lifetime_timer.start(lifetime)
	fade_in(spawn_time)


func start() -> void:
	process_mode = PROCESS_MODE_INHERIT
	lifetime_timer.paused = false


func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	lifetime_timer.paused = true


func fade(duration: float, target: Color) -> void:
	await create_tween()\
			.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)\
			.tween_property(self, "modulate", target, duration)\
			.finished


func fade_in(duration: float) -> void:
	var target: Color = modulate
	modulate.a = 0
	stop()
	await fade(duration, target)
	start()


func fade_out(duration: float) -> void:
	var target: Color = modulate
	target.a = 0
	stop()
	await fade(duration, target)
	queue_free()


func on_hit() -> void:
	modulate = Color.RED
	fade_out(hit_stop)
