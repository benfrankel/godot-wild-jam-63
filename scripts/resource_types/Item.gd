extends Resource
class_name Item

@export var item_name := ""
@export var effects : Array[ItemEffect] = []


func is_consumable() -> bool:
	return not effects.is_empty()
	
func apply_effects(game_state : Variant) -> void:
	for eff in effects:
		var node := Node.new()
		node.set_script(eff.effect_script)
		if "apply" in node:
			node.apply(game_state)
		else:
			push_warning("Invalid item effect found: [ %s ] does not implement 'apply'" % eff.effect_script.resource_path )
