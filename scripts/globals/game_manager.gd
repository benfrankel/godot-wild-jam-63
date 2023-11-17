extends Node
## Globally loaded script for managing all global game data.


const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"
const COMBAT_SCENE := preload("res://scenes/combat/combat.tscn") as PackedScene

var viewport: ViewportManager
var scene_backup: Node
var pausing_allowed := true
# load from default inventory for testing with different items
var player_inventory := preload("res://assets/resources/PlayerDefaultInventory.tres") as Inventory


func enter_room(room_path: String, door_idx: int) -> void:
	var room := (load(room_path) as PackedScene).instantiate() # may cause stutter here for large rooms.
	
	# Teleport player to target door
	if door_idx != -1:
		var player := room.get_node(PLAYER_PATH) as Player
		var door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		door.is_active = false
		player.global_position = door.global_position
	pausing_allowed = false
	(await viewport.swap_scene(room)).queue_free()
	pausing_allowed = true


func enter_combat(enemy_path: String) -> void:
	pausing_allowed = false
	var combat := COMBAT_SCENE.instantiate() as Combat
	combat.enemy = load(enemy_path) as Enemy
	scene_backup = await viewport.swap_scene(combat)


func exit_combat() -> void:
	(await viewport.swap_scene(scene_backup)).queue_free()
	pausing_allowed = true
	

func do_dialog(dialog: Dialog) -> void:
	viewport.do_dialog(dialog)
