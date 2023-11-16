extends Control
class_name VictoryScreen

@export var loot : Inventory
@export var dialog : DialogData

@onready var node_loot :InventoryPanel = $InventoryPanel
@onready var node_dialog :Dialog = $Dialog

func _ready() -> void:
	_load(loot, dialog)

## combat can instance this scene and call this method to automatically set up the screen
func load_from(enemy : Enemy) -> void:
	# holy hell can we get null coalescing please!!??
	var loot := enemy.loot if enemy.loot else self.loot
	var dialog := enemy.dialog if enemy.dialog else self.dialog
	_load(loot, dialog)

func _load(m_loot : Inventory, m_dialog : DialogData) -> void:
	self.loot = m_loot
	self.dialog = m_dialog
	node_loot.load_inventory(loot)
	node_dialog.set_dialog(dialog)
#	if not loot:
#		node_loot.queue_free()

func _on_dialog_dialog_ended() -> void:
	if loot:
		GameManager.player_inventory.consume_inventory(loot)
	queue_free()
