extends Node2D


var fight: Fight


func _ready() -> void:
	print("Fighting ", fight.enemy_name)
	$DurationTimer.start(fight.duration)
	# TODO: Set up the fight (fight.attack_patterns)


func _on_duration_timer_timeout() -> void:
	# TODO: Player wins!
	GameManager.exit_combat()
