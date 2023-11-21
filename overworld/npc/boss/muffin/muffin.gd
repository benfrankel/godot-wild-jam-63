extends StaticBody2D


func _on_interaction_component_combat_won() -> void:
	GameManager.get_tree().change_scene_to_file("res://game/end_screen/end_screen.tscn")
