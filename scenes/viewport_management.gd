extends Node
class_name ViewportManager

@export_file("*.tscn") var main_scene := ""
@export var pause_scene: PackedScene
@export var transition_time := 0.2

@onready var pixel_level_root := $PixelScene/SubViewport as SubViewport
@onready var hi_res_gui_root := $HiResGUIRoot as Control

@onready var trans := $TransitionFX as ColorRect

func _ready() -> void:
	GameManager.viewport = self
	trans.modulate.a = 1.0
	var scene := (load(main_scene) as PackedScene).instantiate()
	swap_scene(scene, false)

func pause(is_paused :bool) -> void:
	get_tree().paused = is_paused

func swap_scene(scene: Node, fade_out := true, fade_in := true) -> Node:
	pause(true)
	if fade_out:
		await fade(1.0)
	
	assert(pixel_level_root.get_child_count() <= 1)
	var prev_scene: Node
	if pixel_level_root.get_child_count() >= 1:
		prev_scene = pixel_level_root.get_child(-1)
		pixel_level_root.remove_child(prev_scene)
	pixel_level_root.add_child(scene)
	
	if fade_in:
		await fade(0.0)
	pause(false)
	
	return prev_scene
	
func fade(target := 1.0) -> void:
	var t := get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(trans, "modulate:a", target, transition_time)
	await t.finished # makes this func awaitable

func do_dialog(dialog : Dialog) -> void:
	if hi_res_gui_root.get_child_count() > 0:
		return
	hi_res_gui_root.add_child(dialog)
	var player := get_tree().get_first_node_in_group(GameManager.PLAYER_GROUP) as Player
	player.is_animated = true
	dialog.tree_exiting.connect(Callable(player, "set").bind("is_animated", false))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_viewport().set_input_as_handled()
		var p := pause_scene.instantiate()
		hi_res_gui_root.add_child(p)
