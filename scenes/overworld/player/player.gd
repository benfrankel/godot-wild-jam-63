class_name Player
extends CharacterBody2D


@export_range(0.0, 1000.0) var speed := 100.0
var is_animated := false
@onready var anim_tree := $AnimationTree as AnimationTree
@onready var interact_sensor := $InteractionSensor as RayCast2D

func _physics_process(_delta: float) -> void:
	if is_animated:
		return

	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()
	
	var is_moving := direction != Vector2.ZERO
	anim_tree.set("parameters/conditions/moving", is_moving)
	anim_tree.set("parameters/conditions/not_moving", !is_moving)
	
	if is_moving:
		# Consider diagonal directions as horizontal
		if direction.x != 0.0 and direction.y != 0.0:
			direction.y = 0.0
		interact_sensor.look_at(interact_sensor.global_position + direction.sign())
		anim_tree.set("parameters/Idle/blend_position", direction)
		anim_tree.set("parameters/Walk/blend_position", direction)
