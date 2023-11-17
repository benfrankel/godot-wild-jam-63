class_name ResultScreen
extends Control


@export var loot: Inventory
@export var dialog: DialogData

@onready var node_loot := $InventoryPanel as InventoryPanel
@onready var node_dialog := $Dialog as Dialog


func _ready() -> void:
	node_loot.load_inventory(loot)
	node_dialog.set_dialog(dialog)
	if not loot:
		node_loot.visible = false


func _on_dialog_dialog_ended() -> void:
	if loot:
		GameManager.player_inventory.consume_inventory(loot)
	queue_free()
