extends InteractionComponent


@export_file("*.tres") var enemy_path := ""


func _interact() -> void:
	GameManager.enter_combat(enemy_path)
