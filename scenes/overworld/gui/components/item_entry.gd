extends HBoxContainer
class_name ItemEntry

signal action_button_pressed

func set_item(item : Item) -> void:
	$Icon.texture = item.texture
	$Label.text = item.item_name

func set_action_name(action_name : String) -> void:
	$BtnAction.text = action_name

func _on_btn_action_pressed() -> void:
	action_button_pressed.emit()
