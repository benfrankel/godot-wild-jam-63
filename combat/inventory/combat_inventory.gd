class_name CombatInventory
extends Control


var combat_state: CombatState

@onready var inv := $InventoryPanel as InventoryPanel


func _on_inventory_panel_item_action_pressed(item: Item) -> void:
	item.apply_effects(combat_state)
	inv.inventory.remove_item(item)
	inv.reload_visuals()
