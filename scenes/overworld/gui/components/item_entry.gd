extends HBoxContainer
class_name ItemEntry

signal action_button_pressed

func set_item(item : Item) -> void:
	$Icon.texture = item.texture
	$Label.text = item.item_name

func set_action_name(action_name : String) -> void:
	$BtnAction.text = action_name

func set_no_action() -> void:
	$BtnAction.queue_free()

func _on_btn_action_pressed() -> void:
	action_button_pressed.emit()

## grabs focus on the entry's button
func do_grab_focus() -> void:
	$BtnAction.grab_focus()
