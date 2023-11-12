class_name Player
extends CharacterBody2D


@export var health := 10.0
@export_range(0.0, 1000.0) var speed := 300.0

@onready var anim_tree := $AnimationTree
@onready var interact_sensor := $InteractionSensor
var is_animated := false # configure in an animation player for cutscene

func _physics_process(_delta: float) -> void:
	interact_sensor.enabled = not is_animated
	if is_animated:
		return
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()
	var temp := velocity
	if temp.length_squared() > 1.0:
		temp = temp.normalized()
	anim_tree.set("parameters/Moving/blend_position", temp)
	var is_moving := temp.length_squared() > 0.5
	anim_tree.set("parameters/conditions/moving", is_moving)
	anim_tree.set("parameters/conditions/not_moving", !is_moving)
	if is_moving:
		interact_sensor.look_at(interact_sensor.global_position + velocity.sign())


func take_damage(damage: float):
	self.health -= damage
