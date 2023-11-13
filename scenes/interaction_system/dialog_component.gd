extends InteractionComponent


@export var dialog: DialogData


func _interact() -> void:
	var d := Dialog.create_dialog(dialog)
	GameManager.do_dialog(d)
