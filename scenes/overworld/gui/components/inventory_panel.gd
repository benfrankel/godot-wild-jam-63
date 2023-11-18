extends PanelContainer
class_name InventoryPanel

enum InventoryStyle {
	OVERWORLD, COMBAT, READONLY
}

signal item_action_pressed(item : Item)

@export var item_entry_scene : PackedScene
@export var inventory : Inventory
@export var style := InventoryStyle.OVERWORLD
## limits visible items to only consumable items. Good for combat focus
@export var filter_consumables := false

@onready var entries := $%ItemEntriesContainer

func _ready() -> void:
	if not inventory:
		inventory = GameManager.player_inventory
	reload_visuals()

func load_inventory(inven : Inventory) -> void:
	inventory = inven
	if not inventory:
		inventory = GameManager.player_inventory
	reload_visuals()

func reload_visuals() -> void:
	for c in entries.get_children():
		c.queue_free()
	var items :Array[Item]= []
	if filter_consumables:
		items.append_array(inventory.get_consumables())
	else:
		items.append_array(inventory.items)
		items.append_array(inventory.boss_items)
	for i in items:
		var entry := item_entry_scene.instantiate() as ItemEntry
		entry.set_item(i)
		match style:
			InventoryStyle.OVERWORLD:
				entry.set_action_name("drop")
				entry.action_button_pressed.connect( \
					Callable(_callback_drop_item).bind(i))
			InventoryStyle.READONLY:
				entry.set_no_action()
		entries.add_child(entry)

func _callback_drop_item(item : Item) -> void:
	item_action_pressed.emit(item)
	inventory.remove_item(item)
	reload_visuals()
