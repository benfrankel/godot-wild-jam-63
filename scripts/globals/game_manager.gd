extends Node
## Globally loaded script for managing all global game data.


const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"
const COMBAT_SCENE := preload("res://scenes/combat/combat.tscn") as PackedScene

var viewport: ViewportManager
var scene_backup: Node


func enter_room(room_path: String, door_idx: int) -> void:
	var room := (load(room_path) as PackedScene).instantiate() # may cause stutter here for large rooms.
	
	# Teleport player to target door
	if door_idx != -1:
		var player := room.get_node(PLAYER_PATH) as Player
		var door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		door.is_active = false
		player.global_position = door.global_position
	
	await viewport.swap_scene(room)


func enter_combat(fight_path: String) -> void:
	var combat := COMBAT_SCENE.instantiate()
	var fight := (load(fight_path) as PackedScene).instantiate() as Fight
	combat.find_child("Projectiles").add_child(fight)
	combat.fight = fight
	scene_backup = await viewport.swap_scene(combat)


func exit_combat() -> void:
	await viewport.swap_scene(scene_backup)


func do_dialog(dialog : Dialog) -> void:
	viewport.do_dialog(dialog)
