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
var player_inventory := preload("res://overworld/player/PlayerDefaultInventory.tres") as Inventory
var combat_size := Vector2(320.0, 180.0)
var overworld_size := Vector2(320.0, 180.0)
var dog_mode := false
var bite_mode := false
var won_last_combat := false


func enter_room(room_path: String, door_idx: int = -1) -> void:
	var room := (load(room_path) as PackedScene).instantiate()
	
	# Teleport player to target door
	if door_idx != -1:
		var player := viewport.pixel_level_root.get_child(0).get_node(PLAYER_PATH) as Player
		var next_player := room.get_node(PLAYER_PATH) as Player
		var next_door := room.get_node(DOORS_PATH).get_children()[door_idx] as Door
		next_player.global_position = next_door.exit_position()
		next_player.speed = player.speed
		var anim_tree := next_player.get_node("AnimationTree") as AnimationTree
		anim_tree.set("parameters/Idle/blend_position", player.anim_tree.get("parameters/Idle/blend_position"))
		anim_tree.set("parameters/Walk/blend_position", player.anim_tree.get("parameters/Walk/blend_position"))

	pausing_allowed = false
	var old_room := await viewport.swap_scene(room, true, false, overworld_size)
	if old_room:
		old_room.queue_free()
	
	var player := viewport.pixel_level_root.get_child(0).get_node(PLAYER_PATH) as Player
	player.anim_tree.advance(0.0)
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
