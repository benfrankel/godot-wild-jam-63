extends Control
class_name Dialog

const DIALOG_SCENE := "res://scenes/dialog_system/dialog.tscn"

## Utility function to load a dialog with specific data
static func create_dialog(data : DialogData) -> Dialog:
	var d := load(DIALOG_SCENE).instantiate() as Dialog
	d.current_data = data
	return d

@onready var character_label := $%CharacterLabel
@onready var textbox := $%TextBox

@export var current_data : DialogData

signal dialog_ended

var line_index := 0
var tween : Tween

# maybe refactor these consts into a settings property?
const TEXT_SPEED := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_dialog(current_data)

func set_dialog(data : DialogData) -> void:
	current_data = data
	if not current_data:
		return
	print("Dialog started: %s" % current_data.resource_path.get_file())
	character_label.text = current_data.character_name
	call_deferred("_load_line")

func _load_line() -> void:
	if tween:
		tween.kill()
	if not current_data:
		return
	if line_index >= current_data.lines.size():
		dialog_ended.emit()
		queue_free()
		return
	
	# prep
	var line := "> " + current_data.lines[line_index]
	if line_index < current_data.lines.size() - 1:
		line += " ..."
	textbox.parse_bbcode(line)
	textbox.visible_ratio = 0.0
	
	# animate
	tween = get_tree().create_tween()
	tween.tween_property(textbox, "visible_ratio", 1.0, TEXT_SPEED)
	tween.tween_callback(_on_line_end)

func _on_line_end() -> void:
	line_index += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		if tween.is_running():
			tween.set_speed_scale(100.0)
			await tween.finished
			tween.set_speed_scale(1.0)
		_load_line()
