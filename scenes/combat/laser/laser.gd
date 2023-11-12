class_name Laser
extends Area2D


var health := 10.0
@export var bounds: Rect2


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	move_to_mouse()
	
func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	move_to_mouse()
	
func move_to_mouse() -> void:
	global_position = get_global_mouse_position().clamp(bounds.position, bounds.end)

func take_damage(damage: float) -> void:
	health -= damage
