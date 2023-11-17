extends Control

@onready var quit_btn := $%BtnQuit
@onready var play_btn := $%BtnPlay
@onready var color_rect := $ColorRect

func _ready() -> void:
	if OS.has_feature("web"):
		# web doesn't support a quit button
		quit_btn.queue_free()
	play_btn.grab_focus()


func _on_btn_play_pressed() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(Callable(get_tree(), "change_scene_to_file").bind("res://scenes/viewport_management.tscn"))


func _on_btn_quit_pressed() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(Callable(get_tree(), "quit"))
