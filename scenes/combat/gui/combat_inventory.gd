extends Control
class_name CombatInventory

var combat_state : CombatState

@onready var inven :InventoryPanel = $InventoryPanel

func _on_inventory_panel_item_action_pressed(item : Item) -> void:
	print("Attempting to apply effects on the combat state from item: %s" % str(item))
	item.apply_effects(combat_state)
	inven.inventory.remove_item(item)
