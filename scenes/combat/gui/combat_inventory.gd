extends Control
class_name CombatInventory

var combat_state : CombatState

@onready var inven :InventoryPanel = $InventoryPanel

func _ready() -> void:
	inven.try_grab_focus()

func _on_inventory_panel_item_action_pressed(item : Item) -> void:
	item.apply_effects(combat_state)
	inven.inventory.remove_item(item)
	inven.reload_visuals()
