extends LineEdit


func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if GameManager.pausing_allowed and not get_tree().paused and event.is_action_pressed("cheat"):
		GameManager.pausing_allowed = false
		get_tree().paused = true
		grab_focus()
		visible = true
		text = ""
		
	if not has_focus():
		return
	
	if event.is_action_pressed("ui_text_newline"):
		GameManager.pausing_allowed = true
		get_tree().paused = false
		release_focus()
		attempt_cheat(text)
		visible = false
		text = ""


func attempt_cheat(code: String) -> void:
	print("Entered cheat code: ", code)
