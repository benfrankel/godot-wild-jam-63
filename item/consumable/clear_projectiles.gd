extends Node

func apply(game_state : CombatState) -> void:
	for c in game_state.projectiles_root.get_children():
		c.queue_free()
