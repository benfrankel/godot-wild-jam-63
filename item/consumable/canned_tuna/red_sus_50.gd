extends Node

func apply(game_state : CombatState) -> void:
	var half :int = ceil(float(game_state.enemy.max_suspicion) / 2.0)
	game_state.suspicion -= half
	game_state.suspicion = max(game_state.suspicion, 0)
