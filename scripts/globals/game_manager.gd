extends Node
"""
	Globally loaded script for managing all global game data, as well as a few singletons that wouldn't work well as singletons

"""

const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"

var viewport : ViewportManager


func enter_room(room_path: String, door_idx: int):
	var room := (load(room_path) as PackedScene).instantiate() # may cause stutter here for large rooms.
	
	# Teleport player to target door
	if door_idx != -1:
		var player := room.get_node(PLAYER_PATH) as Player
		var door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		door.is_active = false
		player.global_position = door.global_position
	
	await viewport.transition_to_scene(room)

func do_dialog(dialog : Dialog) -> void:
	viewport.do_dialog(dialog)
