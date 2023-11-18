class_name InteractionComponent
extends Area2D
## Simple component that can receive an interact call and emits a signal for other component(s) to handle.


signal interacted_with


@export var auto_trigger := false
@export var dialog: DialogData
@export var gift: Array[Item]
@export var enemy: Enemy


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if auto_trigger and body is Player:
		interact()


func interact() -> void:
	interacted_with.emit()
	if dialog:
		await GameManager.do_dialog(Dialog.create_dialog(dialog))
	if gift:
		await GameManager.viewport.do_loot_screen(LootScreen.create(Inventory.from_items(gift.duplicate())))
		gift.clear()
	if enemy:
		GameManager.enter_combat(enemy)
