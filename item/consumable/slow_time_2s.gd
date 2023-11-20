extends Node

const SWITCH_TIME := 0.1
const DURATION := 2.0

func apply(game_state : CombatState) -> void:
	var tree := game_state.projectiles_root.get_tree()
	var tween := tree.create_tween()
	tween.tween_property(Engine, "time_scale", 0.5, SWITCH_TIME)
	tween.tween_interval(DURATION)
	tween.tween_property(Engine, "time_scale", 1.0, SWITCH_TIME)
