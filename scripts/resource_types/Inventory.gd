extends Resource
class_name Inventory

@export var items : Array[Item] = []
@export var boss_items : Array[Item] = []
@export var capacity := 10
@export var boss_items_capacity := 5


static func from_items(item_list: Array[Item]) -> Inventory:
	var inv := Inventory.new()
	for item in item_list:
		inv.add_item(item)
	return inv


func add_item(item: Item) -> bool:
	if item.is_boss_item:
		if boss_items.size() >= boss_items_capacity:
			return false
		boss_items.append(item)
	else:
		if items.size() >= capacity:
			return false
		items.append(item)
	return true

# 
func remove_item(item : Item) -> void:
	if item.is_boss_item:
		if boss_items.has(item):
			boss_items.erase(item)
	else:
		if items.has(item):
			items.erase(item)

## finds only consumable items that are useful in combat
func get_consumables() -> Array[Item]:
	var agg :Array[Item]= []
	for item in items:
		if item.is_consumable():
			agg.append(item)
	for item in boss_items:
		if item.is_consumable():
			agg.append(item)
	return agg

## used to add all items from a secondary inventory resource to this one
func consume_inventory(other : Inventory) -> void:
	for item in other.items:
		add_item(item)
	for item in other.boss_items:
		add_item(item)
