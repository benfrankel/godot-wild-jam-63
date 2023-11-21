extends Control
class_name Dialog


signal dialog_ended


const DIALOG_SCENE := "res://overworld/dialog/dialog.tscn"

@export var current_data: DialogData

var line_index := 0
var tween: Tween

@onready var character_label := %CharacterLabel as Label
@onready var textbox := %TextBox as RichTextLabel
@onready var sfx_progress := $SFX_Progress as AudioStreamPlayer


## Utility function to load a dialog with specific data
static func create_dialog(data: DialogData) -> Dialog:
	var d := load(DIALOG_SCENE).instantiate() as Dialog
	d.current_data = data
	return d


func _ready() -> void:
	set_dialog(current_data)


func set_dialog(data: DialogData) -> void:
	current_data = data
	if not current_data:
		return
	character_label.text = current_data.character_name
	call_deferred("_load_line")


func _load_line() -> void:
	if tween:
		tween.kill()
	if not current_data or line_index >= current_data.lines.size():
		dialog_ended.emit()
		queue_free()
		return
	
	# prep
	var line := "> " + current_data.lines[line_index]
	if line_index < current_data.lines.size() - 1:
		line += " [...]"
	textbox.parse_bbcode(line)
	textbox.visible_ratio = 0.0
	
	# animate
	tween = get_tree().create_tween()
	var duration := textbox.get_parsed_text().length() / current_data.text_speed
	tween.tween_property(textbox, "visible_ratio", 1.0, duration)
	tween.tween_callback(_on_line_end)


func _on_line_end() -> void:
	line_index += 1


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return

	get_viewport().set_input_as_handled()
	if tween and tween.is_running():
		tween.set_speed_scale(100.0)
		await tween.finished
		tween.set_speed_scale(1.0)
	else:
		_load_line()
	sfx_progress.play()
