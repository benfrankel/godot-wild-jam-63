class_name InteractionComponent
extends Area2D
## Simple component that can receive an interact call and emits a signal for other component(s) to handle.


signal interacted_with


@export var auto_trigger := false
@export var one_shot := false
@export var dialog: DialogData
@export var gift: Array[Item]
@export var enemy: Enemy
var is_active := true


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if auto_trigger and body is Player:
		await interact()
		is_active = false


func _on_body_exited(body: Node2D) -> void:
	if auto_trigger and not one_shot and body is Player:
		is_active = true


func interact() -> void:
	if not is_active:
		return
	if one_shot:
		is_active = false

	interacted_with.emit()
	if dialog:
		await GameManager.do_dialog(Dialog.create_dialog(dialog))
	if gift:
		await GameManager.viewport.do_loot_screen(LootScreen.create(Inventory.from_items(gift.duplicate())))
		gift.clear()
	if enemy:
		if await GameManager.enter_combat(enemy):
			enemy = null
