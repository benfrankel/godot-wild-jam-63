class_name Laser
extends Area2D


var health := 10.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	move_to_mouse()


func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(_delta: float) -> void:
	move_to_mouse()
	
	
func get_global_bounds() -> Rect2:
	var bounds: Rect2 = ($"../Arena/Bounds".shape as RectangleShape2D).get_rect()
	bounds.position += $"../Arena".global_position
	return bounds


func move_to_mouse() -> void:
	var bounds: Rect2 = get_global_bounds()
	global_position = get_global_mouse_position().clamp(bounds.position, bounds.end)


func take_damage(damage: float) -> void:
	health -= damage
