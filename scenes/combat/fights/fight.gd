class_name Fight
extends Node


signal attack_launched(projectile: Projectile)
signal player_won

## The enemy's name.
@export var enemy_name := ""


func _on_duration_timer_timeout() -> void:
	player_won.emit()
