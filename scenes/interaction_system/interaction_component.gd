extends Area2D
class_name InteractionComponent

"""
Simple component that can receive an interact call and emits a signal for other component(s) to handle
"""

signal interacted_with

func interact() -> void:
	interacted_with.emit()
