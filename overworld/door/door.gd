class_name Door
extends Area2D


@export_file("*.tscn") var target_room := ""
@export var target_door := -1
@export var require: Item

var is_active := true


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(GameManager.PLAYER_GROUP):
		return
	if not is_active:
		is_active = true
		return
	if require and not GameManager.player_inventory.has_item(require):
		return
	GameManager.enter_room(target_room, target_door)