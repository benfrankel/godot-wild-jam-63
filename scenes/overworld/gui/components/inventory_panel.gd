extends PanelContainer

enum InventoryStyle {
	OVERWORLD, COMBAT
}


@export var item_entry_scene : PackedScene
@export var inventory : Inventory
@export var style := InventoryStyle.OVERWORLD

@onready var entries := $%ItemEntriesContainer


var filter_consumables := false

func _ready() -> void:
	if inventory:
		reload_visuals()

func load_inventory(inven : Inventory) -> void:
	inventory = inven
	if inventory:
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
	print("Inventory panel found: %s items" % str(items.size()))
	for i in items:
		var entry := item_entry_scene.instantiate() as ItemEntry
		entry.set_item(i)
		match style:
			InventoryStyle.OVERWORLD:
				entry.set_action_name("drop")
				entry.action_button_pressed.connect( \
					Callable(_callback_drop_item).bind(i))
			InventoryStyle.COMBAT:
				entry.set_action_name("use")
				entry.action_button_pressed.connect( \
					Callable(_callback_use_item).bind(i))
		entries.add_child(entry)

func _callback_drop_item(item : Item) -> void:
	pass

func _callback_use_item(item : Item) -> void:
	pass
