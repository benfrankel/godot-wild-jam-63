extends Node
class_name ViewportManager

@export_file("*.tscn") var main_scene := ""

@export var transition_time := 0.2

@onready var pixel_level_root := $PixelScene/SubViewport
@onready var hi_res_gui_root := $HiResGUIRoot

@onready var trans := $TransitionFX

func _ready() -> void:
	GameManager.viewport = self
	trans.modulate.a = 1.0
	load_scene(main_scene)

func pause(is_paused :bool) -> void:
	get_tree().paused = is_paused

## manages a sequence for the 
func load_scene(path : String) -> void:
	pause(true)
	await _fade(1.0)
	for c in pixel_level_root.get_children():
		c.queue_free() # should only ever be one, but let's manage edge cases
	var scene := (load(path) as PackedScene).instantiate() # may cause stutter here for large levels.
	pixel_level_root.add_child(scene)
	await _fade(0.0)
	pause(false)
	GameManager.level_finished_loading.emit()

	
	
func _fade(target :float = 1.0) -> void:
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
