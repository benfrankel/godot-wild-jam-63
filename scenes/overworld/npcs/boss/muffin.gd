extends StaticBody2D



func _on_interaction_component_combat_won() -> void:
	get_tree().change_scene_to_file("res://scenes/gui/end_screen.tscn")
