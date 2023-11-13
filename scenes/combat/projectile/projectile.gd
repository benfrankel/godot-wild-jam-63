class_name Projectile
extends Area2D


@export var damage := 1.0
@export_range(0.0, 1000.0) var speed := 300.0
@export_range(0.0, TAU) var angle := 0.0


func _on_body_entered(body: Node2D):
	if body is Laser:
		hit_laser(body)


func hit_laser(laser: Laser):
	queue_free()
	laser.take_damage(damage)
