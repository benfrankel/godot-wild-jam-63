extends Node
class_name NPCComponent

@export var dialog : DialogData


func on_interacted() -> void:
	var d := Dialog.create_dialog(dialog)
	GameManager.do_dialog(d)
