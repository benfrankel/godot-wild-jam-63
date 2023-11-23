class_name Door
extends Area2D


@export var target_room: int = -1
@export var target_door: int = -1
@export var requirement: Item


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(GameManager.PLAYER_GROUP):
		return
	if requirement and not GameManager.player.inventory.has_item(requirement):
		return

	GameManager.enter_room(target_room, target_door)


func exit_position() -> Vector2:
	return ($Exit as Marker2D).global_position
