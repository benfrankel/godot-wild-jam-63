extends Control

@export var speed_factor := 10.0

@onready var anim := $AnimationPlayer

var tween : Tween
func _input(event: InputEvent) -> void:
	if event.is_action("interact"):
		var speed :float = 1.0 if event.is_released() else speed_factor
		if tween:
			tween.kill()
		tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(anim, "speed_scale", speed, 0.3)

func _on_end() -> void:
	get_tree().change_scene_to_file("res://viewport_management.tscn")
