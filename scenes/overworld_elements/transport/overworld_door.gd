extends Area2D
class_name OverworldDoor

@export_file("*.tscn") var target_scene := ""
@export var door_target := ""
@export var player_group := "player"
@export var safety_disable_time := 1.0

func _ready() -> void:
	# little safety to prevent getting stuck in a portal loop
	monitoring = false; # monitoring is managed by level loading logic
	GameManager.level_finished_loading.connect(do_enter, CONNECT_ONE_SHOT | CONNECT_DEFERRED)

func do_enter() -> void:
	if GameManager.current_door_target == name:
		body_exited.connect(_exit_handler)
		var player := get_tree().get_first_node_in_group(player_group) as Node2D
		player.global_position = global_position
	else:
		monitoring = true

func _exit_handler(body : Node2D) -> void:
	if not body.is_in_group(player_group):
		return
	monitoring = true
	body_exited.disconnect(_exit_handler)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(player_group):
		return
	GameManager.current_door_target = door_target
	GameManager.viewport.load_scene(target_scene)
