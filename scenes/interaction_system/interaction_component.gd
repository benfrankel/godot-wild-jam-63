class_name InteractionComponent
extends Area2D
## Simple component that can receive an interact call and emits a signal for other component(s) to handle.


signal interacted_with

@export var dialog: DialogData
@export var enemy: Enemy


func interact() -> void:
	interacted_with.emit()
	if dialog:
		await GameManager.do_dialog(Dialog.create_dialog(dialog))
	if enemy:
		GameManager.enter_combat(enemy)
