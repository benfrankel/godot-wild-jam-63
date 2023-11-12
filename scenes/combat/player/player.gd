class_name CombatPlayer
extends CharacterBody2D


var health := 10.0
@export_range(0.0, 1000.0) var speed := 500.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()

func take_damage(damage: float) -> void:
	health -= damage
