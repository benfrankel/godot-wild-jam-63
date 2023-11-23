extends Node
## Globally loaded script for managing all global game data.


signal exited_combat()


const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"
const COMBAT_SCENE := preload("res://combat/combat.tscn") as PackedScene

var viewport: ViewportManager
var scene_backup: Node
var pausing_allowed := false
# load from default inventory for testing with different items
var player: Player
var combat_size := Vector2(320.0, 180.0)
var overworld_size := Vector2(320.0, 180.0)
var dog_mode := false
var bite_mode := false
var won_last_combat := false
var rooms: Array[Node] = [
	preload("res://overworld/room/intro_room.tscn").instantiate(),
	preload("res://overworld/room/main_street.tscn").instantiate(),
	preload("res://overworld/room/sandwich_shop.tscn").instantiate(),
	preload("res://overworld/room/tailor_shop.tscn").instantiate(),
	preload("res://overworld/room/church.tscn").instantiate(),
	preload("res://overworld/room/hideout.tscn").instantiate(),
]


func enter_room(room_idx: int, door_idx: int = -1) -> void:
	assert(0 <= room_idx and room_idx < rooms.size())
	var room := rooms[room_idx]
	if not player:
		player = room.get_node(PLAYER_PATH) as Player

	pausing_allowed = false
	
	await viewport.swap_scene(room, true, false, overworld_size)
	
	# Teleport player into the room at the exit door
	if door_idx != -1:
		var exit_door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		player.global_position = exit_door.exit_position()
	player.reparent(room.get_node("TileMap"))

	viewport.pause(true)
	await viewport.fade(0.0)
	viewport.pause(false)
	
	pausing_allowed = true


func enter_combat(enemy: Enemy) -> bool:
	pausing_allowed = false
	var combat := COMBAT_SCENE.instantiate() as Combat
	combat.enemy = enemy.duplicate()
	if dog_mode:
		combat.enemy.max_suspicion = 1
	if enemy.is_mafia:
		combat.get_node("BGMLoad").music = combat.MAFIA_MUSIC
	scene_backup = await viewport.swap_scene(combat, true, true, combat_size)
	await exited_combat
	return won_last_combat


func exit_combat(win: bool) -> void:
	won_last_combat = win
	exited_combat.emit()
	(await viewport.swap_scene(scene_backup, true, true, overworld_size)).queue_free()
	pausing_allowed = true
	

func do_dialog(dialog: Dialog) -> void:
	await viewport.do_dialog(dialog)
