extends Node
## Globally loaded script for managing all global game data.


signal exited_combat()
signal unlocked()


const PLAYER_GROUP := "player"
const PLAYER_PATH := "%Player"
const DOORS_PATH := "%Doors"
const COMBAT_SCENE := preload("res://combat/combat.tscn") as PackedScene

var is_locked := true
var viewport: ViewportManager
var player: Player
var rooms: Array[Node] = [
	preload("res://overworld/room/intro_room.tscn").instantiate(),
	preload("res://overworld/room/main_street.tscn").instantiate(),
	preload("res://overworld/room/sandwich_shop.tscn").instantiate(),
	preload("res://overworld/room/tailor_shop.tscn").instantiate(),
	preload("res://overworld/room/church.tscn").instantiate(),
	preload("res://overworld/room/hideout.tscn").instantiate(),
]
var current_room_idx: int
var combat_size := Vector2(320.0, 180.0)
var overworld_size := Vector2(320.0, 180.0)
var won_last_combat := false
var dog_mode := false
var bite_mode := false


func lock() -> void:
	if is_locked:
		await unlocked
	is_locked = true
	if player:
		player.anim_tree.set("parameters/conditions/moving", false)
		player.anim_tree.set("parameters/conditions/not_moving", true)


func unlock() -> void:
	is_locked = false
	unlocked.emit()


func enter_room(room_idx: int, door_idx: int = -1) -> void:
	assert(0 <= room_idx and room_idx < rooms.size())
	await lock()
	var room := rooms[room_idx]
	if not player:
		player = room.get_node(PLAYER_PATH) as Player
	
	await viewport.swap_scene(room, true, false, overworld_size)
	current_room_idx = room_idx
	
	# Teleport player into the room at the exit door
	if door_idx != -1:
		var exit_door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		player.global_position = exit_door.exit_position()
	player.reparent(room.get_node("TileMap"))

	viewport.pause(true)
	await viewport.fade(0.0)
	viewport.pause(false)
	unlock()


func do_combat(enemy: Enemy) -> bool:
	await lock()
	var combat := COMBAT_SCENE.instantiate() as Combat
	combat.enemy = enemy.duplicate()
	if dog_mode:
		combat.enemy.max_suspicion = 1
	if enemy.is_mafia:
		combat.get_node("BGMLoad").music = combat.MAFIA_MUSIC
	await viewport.swap_scene(combat, true, true, combat_size)
	await exited_combat
	unlock()
	return won_last_combat


func exit_combat(win: bool) -> void:
	won_last_combat = win
	exited_combat.emit()
	var room := rooms[current_room_idx]
	(await viewport.swap_scene(room, true, true, overworld_size)).queue_free()
	

func do_ui(node: Node) -> void:
	await lock()
	viewport.hi_res_gui_root.call_deferred("add_child", node)
	await node.tree_exiting
	unlock()
