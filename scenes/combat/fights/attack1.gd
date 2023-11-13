class_name Attack
extends Node2D


@export var projectile: PackedScene


func _on_cooldown_timer_timeout() -> void:
	var child := projectile.instantiate() as Projectile
	add_child(child)
