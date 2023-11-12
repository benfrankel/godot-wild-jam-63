class_name Projectile
extends Area2D


@export var damage := 1.0
@export_range(0.0, 2000.0) var speed := 800.0
@export_range(0.0, TAU) var angle := 0.0


func _process(delta: float):
	var direction := Vector2.from_angle(angle)
	var velocity := speed * direction
	position += delta * velocity

func _on_body_entered(body: Node2D):
	if body is Laser:
		hit_laser(body)
		
func hit_laser(laser: Laser):
	queue_free()
	laser.take_damage(damage)
