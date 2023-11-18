extends Area2D
class_name CombatArea
"""
Translates any arbitrary collider (including CollisionPolygon2D) into a grid of cells where each cell triggers a new rng check for starting a fight. This also allows different areas to have different fights available
"""


@export var cell_size := 32.0
@export_range(0, 1) var chance_combat_per_cell := 0.2
# use the resource refs so it is resiliant to file moves
@export var enemy_list: Array[Enemy] = []
@export var clear_on_win := false

var last_cell := Vector2.ONE * -1
var target_body : Node2D

func _ready() -> void:
	body_entered.connect(_on_body_enter)
	body_exited.connect(_on_body_exit)

func _physics_process(_delta: float) -> void:
	if not target_body:
		return
	var curr_cell := _get_cell(target_body.global_position)
	if curr_cell != last_cell:
		last_cell = curr_cell
		_try_do_combat()

func _try_do_combat() -> void:
	if randf() < chance_combat_per_cell:
		var enemy: Enemy = enemy_list.pick_random() if enemy_list else EnemyGen.random_enemy()
		GameManager.enter_combat(enemy)

func _get_cell(global_pos : Vector2) -> Vector2:
	return (global_pos / cell_size).floor()

func _on_body_enter(body : Node2D) -> void:
	if body.is_in_group(GameManager.PLAYER_GROUP):
		target_body = body

func _on_body_exit(body : Node2D) -> void:
	if body == target_body:
		target_body = null
