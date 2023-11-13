extends Node


var fight: Fight


func _ready() -> void:
	if not fight:
		return
	print("Fighting ", fight.enemy_name)
