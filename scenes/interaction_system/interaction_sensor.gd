extends RayCast2D


## emitted when a new interaction is found
signal target_found(target: Node)
## emitted when an interaction is no longer available
signal target_lost

## the current target interaction, or null
var target: InteractionComponent
@onready var interact_sfx := $"../SFX_Interact"


func _process(_delta: float) -> void:
	if enabled and target and Input.is_action_just_pressed("interact"):
		get_viewport().set_input_as_handled()
		interact_sfx.play()
		enabled = false
		await target.interact()
		await get_tree().create_timer(0.25).timeout
		enabled = true


func _physics_process(_delta: float) -> void:
	var seen = get_collider() as InteractionComponent
	if target and not seen:
		target = null
		target_lost.emit()
	elif target != seen:
		target = seen
		target_found.emit(target)
