extends RayCast2D


## emitted when a new interaction is found
signal target_found(target: Node)
## emitted when an interaction is no longer available
signal target_lost

## the current target interaction, or null
var target: InteractionComponent


func _physics_process(_delta: float) -> void:
	var seen = get_collider() as InteractionComponent
	if target and not seen:
		target = null
		target_lost.emit()
	elif target != seen:
		target = seen
		target_found.emit(target)


func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	if target and event.is_action_pressed("interact"):
		target.interact()
		get_viewport().set_input_as_handled()
		
