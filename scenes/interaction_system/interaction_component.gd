class_name InteractionComponent
extends Area2D
## Simple component that can receive an interact call and emits a signal for other component(s) to handle.


signal interacted_with


func interact() -> void:
	interacted_with.emit()
