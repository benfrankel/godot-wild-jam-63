class_name CombatItemEntry
extends PanelContainer


var slot: int
var combat_state: CombatState

@onready var stylebox := get_theme_stylebox("panel") as StyleBoxFlat
@onready var icon := $ItemIcon as TextureRect


func _ready() -> void:
	update()


func _process(_delta: float) -> void:
	update()


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept") or not has_focus():
		return
	
	var item := GameManager.player_inventory.items.pop_at(slot) as Item
	item.apply_effects(combat_state)


func update() -> void:
	icon.texture = GameManager.player_inventory.items[slot].texture
	if has_focus():
		stylebox.set_border_width_all(1)
	else:
		stylebox.set_border_width_all(0)
