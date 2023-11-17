extends VBoxContainer



func _on_combat_player_damaged() -> void:
	if not GameManager.bite_mode:
		return
	var vfx := preload("res://assets/vfx/bite_vfx.tscn").instantiate()
	add_child(vfx)
