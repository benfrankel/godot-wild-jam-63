extends LineEdit


@onready var vfx_rect := $"../../ScreenVFX" as ColorRect
@onready var backup_vfx := vfx_rect.material as ShaderMaterial


func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_newline") and has_focus():
		get_viewport().set_input_as_handled()
		exit_cheat_mode()
	elif event.is_action_pressed("cheat") and GameManager.pausing_allowed and not get_tree().paused:
		enter_cheat_mode()


func enter_cheat_mode() -> void:
	GameManager.pausing_allowed = false
	get_tree().paused = true
	grab_focus()
	visible = true
	text = ""
	
	var vfx := vfx_rect.material.duplicate() as ShaderMaterial
	vfx.set_shader_parameter("resolution", Vector2(320.0, 240.0))
	vfx.set_shader_parameter("pixelate", true)
	vfx.set_shader_parameter("brightness", 0.8)
	vfx.set_shader_parameter("discolor", true)
	var tween_map := {
		"scanlines_opacity": 0.25,
		"grille_opacity": 0.25,
		"static_noise_intensity": 0.05,
	}
	var tween_duration := 0.25
	var tween := create_tween()
	for key in tween_map.keys():
		tween.tween_method(
			func(x): vfx.set_shader_parameter(key, x),
			backup_vfx.get_shader_parameter(key),
			tween_map[key],
			tween_duration,
		)
	vfx_rect.material = vfx


func exit_cheat_mode() -> void:
	GameManager.pausing_allowed = true
	get_tree().paused = false
	release_focus()
	attempt_cheat(text)
	visible = false
	text = ""
	
	vfx_rect.material = backup_vfx


func attempt_cheat(code: String) -> void:
	match code:
		"/hocuspocus": do_hocuspocus()
		"/pspspsps": do_pspspsps()
		"/any%": do_anypercent()
		"/openyoureyes": do_openyoureyes()
		"/dogmode": do_dogmode()
		_: print("Invalid cheat code: ", code)


func do_hocuspocus() -> void:
	pass


func do_pspspsps() -> void:
	GameManager.enter_combat(EnemyGen.random_enemy())


func do_anypercent() -> void:
	GameManager.player_speed = 200.0
	GameManager.update_player_speed()


func do_openyoureyes() -> void:
	GameManager.viewport.pixel_level_root.size_2d_override = Vector2(640.0, 360.0)


func do_dogmode() -> void:
	pass
