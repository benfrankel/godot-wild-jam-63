class_name ViewportManager
extends Node


@export var pause_scene: PackedScene
@export var transition_time := 0.2

@onready var pixel_level_root := $PixelScene/SubViewport as SubViewport
@onready var hi_res_gui_root := $HiResGUIRoot as Control
@onready var trans := $TransitionFX as ColorRect


func _ready() -> void:
	GameManager.viewport = self


func pause(is_paused: bool) -> void:
	if is_inside_tree():
		get_tree().paused = is_paused


func swap_scene(scene: Node, fade_out := true, fade_in := true, new_size := Vector2.ZERO) -> Node:
	pause(true)
	if fade_out:
		await fade(1.0)
	
	if new_size != Vector2.ZERO:
		pixel_level_root.size_2d_override = new_size
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


func _unhandled_input(event: InputEvent) -> void:
	if not GameManager.is_locked and event.is_action_pressed("exit"):
		get_viewport().set_input_as_handled()
		GameManager.do_ui(pause_scene.instantiate())
