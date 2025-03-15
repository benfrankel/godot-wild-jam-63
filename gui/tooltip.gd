class_name Tooltip
extends Panel


const TOOLTIP_SCENE := preload("res://gui/tooltip.tscn") as PackedScene


static func create(content: String) -> Object:
	var tooltip := TOOLTIP_SCENE.instantiate()
	(tooltip.get_node("Label") as Label).text = content
	return tooltip
