extends RayCast2D
class_name InteractionSensor

## emitted when a new interaction is found and it is not the previously found interactable
signal interaction_available(name: String)
## emitted when interaction is no longer available
signal interaction_unavailable

## the last object to be found that is interactable
var last_interactable :Node = null


func _ready() -> void:
	collide_with_areas = true

func _physics_process(_delta: float) -> void:
	if not is_colliding():
		return
	var coll := get_collider()
	if "interact" in coll:
		if coll != last_interactable:
			interaction_available.emit(coll.name)
			last_interactable = coll
	elif last_interactable:
		last_interactable = null
		interaction_unavailable.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	if event.is_action_pressed("interact") and last_interactable:
		last_interactable.interact() # safety checked in physics process
		get_viewport().set_input_as_handled()
		
