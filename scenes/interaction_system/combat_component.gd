extends InteractionComponent


@export_file("*.tscn") var fight_path := ""


func _interact() -> void:
	GameManager.enter_combat(fight_path)
