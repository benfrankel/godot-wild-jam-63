extends Node

func apply(game_state : CombatState) -> void:
	var quarter :int = ceil(float(game_state.enemy.max_exhaustion) / 4.0)
	game_state.exhaustion += quarter
