extends Control

@onready var first_button := $MainPanel/PanelContainer/MarginContainer/VBoxContainer/BtnInventory
@onready var inventory_panel := $InventoryPanel

var prior_mouse_state : Input.MouseMode

func _ready() -> void:
	prior_mouse_state = Input.mouse_mode # grab previous state
	if not GameManager.pausing_allowed:
		# mouse state is automatically applied when leaving the tree for any reason, so we need to know the state before queue free
		queue_free()
		return
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # pause menu requires mouse access
	get_tree().paused = true
	first_button.grab_focus()
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

func _exit_tree() -> void:
	Input.mouse_mode = prior_mouse_state # reset to previous state
