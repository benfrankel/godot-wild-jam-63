class_name Player
extends CharacterBody2D


@export var health := 10.0
@export_range(0.0, 1000.0) var speed := 300.0

var is_animated := false # configure in an animation player for cutscene

func _physics_process(_delta: float) -> void:
	if is_animated:
		return
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()


func take_damage(damage: float):
	self.health -= damage
