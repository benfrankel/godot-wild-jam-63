extends Resource
class_name DialogData

@export var character_name : String = ""
@export var text_sound : AudioStream
@export var text_speed := 40.0
@export var auto_progress := false
@export var lines : Array[String] = []
