extends Control

@onready var save_button := $MainPanel/PanelContainer/MarginContainer/VBoxContainer/BtnSave
@onready var inventory_panel := $InventoryPanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	save_button.grab_focus()
	inventory_panel.visible = false




func _on_btn_save_pressed() -> void:
	pass # Replace with function body.


func _on_btn_inventory_pressed() -> void:
	inventory_panel.visible = not inventory_panel.visible


func _on_btn_quit_pressed() -> void:
	push_warning("this should move to a main menu once implemented")
	get_tree().quit()


func _on_inventory_panel_focus_exited() -> void:
	inventory_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
