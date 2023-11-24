extends Control


@export_file("*.tscn") var start_ui := ""
@export var start_room: int = -1

@onready var quit_btn := %BtnQuit as Button
@onready var play_btn := %BtnPlay as Button
@onready var color_rect := $ColorRect as ColorRect


func _ready() -> void:
	if OS.has_feature("web"):
		# web doesn't support a quit button
		quit_btn.queue_free()
	play_btn.grab_focus()


func _on_btn_play_pressed() -> void:
	queue_free()
	var ui := (load(start_ui) as PackedScene).instantiate()
	GameManager.viewport.hi_res_gui_root.add_child(ui)
	GameManager.unlock()
	GameManager.enter_room(start_room)


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
