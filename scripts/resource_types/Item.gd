extends Resource
class_name Item

@export var item_name := ""
@export var texture : Texture2D
@export var effects : Array[Script] = []
@export var is_boss_item := false

func is_consumable() -> bool:
	return not effects.is_empty()
	
func apply_effects(game_state : CombatState) -> void:
	for eff in effects:
		var node := Node.new()
		node.set_script(eff)
		if "apply" in node:
			node.apply(game_state)
			game_state.emit_changed()
		else:
			push_warning("Invalid item effect found: [ %s ] does not implement 'apply'" % eff.effect_script.resource_path )
