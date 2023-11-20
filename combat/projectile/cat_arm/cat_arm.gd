extends Projectile


var follow_time := 1.0
var is_following := true
var follow_axis: Vector2


func _ready() -> void:
	follow_axis = linear_velocity.normalized().rotated(PI / 2.0)
	
	await super._ready()
	
	stop()
	await get_tree().create_timer(follow_time, false).timeout
	is_following = false
	start()


func _physics_process(_delta: float) -> void:
	if is_following:
		position += laser.position.project(follow_axis) - position.project(follow_axis)


func expire() -> void:
	stop()
	super.expire()
