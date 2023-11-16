extends Control
class_name VictoryScreen


@export var loot: Inventory
@export var dialog: DialogData

@onready var node_loot := $InventoryPanel as InventoryPanel
@onready var node_dialog := $Dialog as Dialog


func _ready() -> void:
	_load()


## combat can instance this scene and call this method to automatically set up the screen
func load_from(enemy: Enemy) -> void:
	if enemy.loot:
		loot = enemy.loot
	if enemy.dialog:
		dialog = enemy.dialog
	_load()


func _load() -> void:
	node_loot.load_inventory(loot)
	node_dialog.set_dialog(dialog)
#	if not loot:
#		node_loot.queue_free()


func _on_dialog_dialog_ended() -> void:
	if loot:
		GameManager.player_inventory.consume_inventory(loot)
	queue_free()
