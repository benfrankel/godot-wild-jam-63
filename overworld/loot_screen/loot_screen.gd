class_name LootScreen
extends Control


const LOOT_SCREEN_SCENE := "res://overworld/loot_screen/loot_screen.tscn"

@export var loot: Inventory

@onready var node_loot := $CenterContainer/VBoxContainer/InventoryPanel as InventoryPanel


static func create(inv: Inventory) -> LootScreen:
	var l := load(LOOT_SCREEN_SCENE).instantiate() as LootScreen
	l.loot = inv
	return l


func _ready() -> void:
	node_loot.load_inventory(loot)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		queue_free()
