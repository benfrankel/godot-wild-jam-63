class_name ItemEntry
extends HBoxContainer


signal action_button_pressed


@onready var button := $BtnAction as Button
@onready var icon := $Icon as TextureRect
@onready var label := $Label as Label


func set_item(item: Item) -> void:
	icon.texture = item.texture
	label.text = item.item_name
	tooltip_text = item.description


func set_action_name(action_name: String) -> void:
	button.text = action_name


func set_no_action() -> void:
	button.queue_free()


func _on_btn_action_pressed() -> void:
	action_button_pressed.emit()
