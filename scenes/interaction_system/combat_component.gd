extends InteractionComponent


@export_file("*.tres") var fight_path := ""


func _interact() -> void:
	GameManager.enter_combat(fight_path)
