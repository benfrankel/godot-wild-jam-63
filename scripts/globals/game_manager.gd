extends Node
"""
	Globally loaded script for managing all global game data, as well as a few singletons that wouldn't work well as singletons

"""

const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"
const COMBAT_SCENE := preload("res://scenes/combat/combat.tscn") as PackedScene

var viewport : ViewportManager
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
	
func enter_combat(_enemy_path: String) -> void:
	var combat := COMBAT_SCENE.instantiate()
	# TODO: Load enemy scene and add it to the combat instance
	scene_backup = await viewport.swap_scene(combat)
	
func exit_combat() -> void:
	await viewport.swap_scene(scene_backup)

func do_dialog(dialog : Dialog) -> void:
	viewport.do_dialog(dialog)
