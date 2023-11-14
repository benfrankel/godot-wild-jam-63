class_name Projectile
extends RigidBody2D


## Time in seconds before the projectile starts moving.
@export var wait_time := 0.5
## Time to freeze in place after hitting the laser.
@export var hit_stop := 0.3
var lifetime: float
var lifetime_timer := Timer.new()


func _ready() -> void:
	lifetime_timer.timeout.connect(fade_away)
	lifetime_timer.one_shot = true
	add_child(lifetime_timer)
	lifetime_timer.start(lifetime)
	start_after_wait()


func start_after_wait() -> void:
	stop()
	modulate = Color.TRANSPARENT
	await create_tween()\
			.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)\
			.tween_property(self, "modulate", Color.WHITE, wait_time)\
			.finished
	start()


func start() -> void:
	process_mode = PROCESS_MODE_INHERIT
	lifetime_timer.paused = false


func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	lifetime_timer.paused = true


func fade_away() -> void:
	stop()
	var transparent: Color = modulate
	transparent.a = 0
	await create_tween()\
			.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)\
			.tween_property(self, "modulate", transparent, hit_stop)\
			.finished
	queue_free()


func on_hit() -> void:
	modulate = Color.RED
	fade_away()
