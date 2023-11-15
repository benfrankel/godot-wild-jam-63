extends Projectile


var follow_time := 1.0
var is_following := true
var x_axis: Vector2
var y_axis: Vector2
var target: Vector2


func _ready() -> void:
	x_axis = linear_velocity.normalized()
	y_axis = x_axis.rotated(PI / 2.0)
	
	await super._ready()
	
	stop()
	await get_tree().create_timer(follow_time, false).timeout
	is_following = false
	target = laser.position.project(x_axis)
	start()


func _physics_process(delta: float) -> void:
	if is_following:
		position += laser.position.project(y_axis) - position.project(y_axis)
	elif (position.project(x_axis) - target).dot(x_axis) >= 0:
		stop()
		fade_out(despawn_time)
