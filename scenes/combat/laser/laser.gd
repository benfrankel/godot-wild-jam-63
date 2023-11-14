class_name Laser
extends Area2D


signal got_hit(projectile: Projectile)


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	move_to_mouse()


func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(_delta: float) -> void:
	move_to_mouse()


func _on_body_entered(body: Node2D):
	var projectile := body as Projectile
	if projectile:
		projectile.on_hit()
		got_hit.emit(projectile)


func move_to_mouse() -> void:
	var arena: Rect2 = $"..".get_global_arena_rect()
	global_position = get_global_mouse_position().clamp(arena.position, arena.end)
