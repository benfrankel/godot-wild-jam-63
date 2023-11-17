class_name Item
extends Resource


@export var item_name := ""
@export var description := ""
@export var texture: Texture2D
@export var effects: Array[Script] = []
@export var is_boss_item := false


func is_consumable() -> bool:
	return not effects.is_empty()


func apply_effects(combat_state: CombatState) -> void:
	for eff in effects:
		var node := Node.new()
		node.set_script(eff)
		if "apply" in node:
			node.apply(combat_state)
			combat_state.emit_changed()
		else:
			push_warning("Invalid item effect found: [ %s ] does not implement 'apply'" % eff.effect_script.resource_path )
