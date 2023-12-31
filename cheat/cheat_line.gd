extends LineEdit


@onready var vfx_rect := $"../../ScreenVFX" as ColorRect
@onready var backup_vfx := vfx_rect.material as ShaderMaterial


func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_newline") and has_focus():
		get_viewport().set_input_as_handled()
		exit_cheat_mode()
	elif event.is_action_pressed("cheat") and not GameManager.is_locked:
		enter_cheat_mode()


func enter_cheat_mode() -> void:
	await GameManager.lock()
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
	get_tree().paused = false
	release_focus()
	attempt_cheat(text)
	visible = false
	text = ""
	
	vfx_rect.material = backup_vfx
	GameManager.unlock()


func attempt_cheat(code: String) -> void:
	match code:
		"/hocuspocus": do_hocuspocus()
		"/pspspsps": do_pspspsps()
		"/any%": do_anypercent()
		"/openyoureyes": do_openyoureyes()
		"/dogmode": do_dogmode()
		"/1987" : do_bite_mode()
		"/pyrious": do_pyrious()
		"/clear": do_clear()
		_: print("Invalid cheat code: ", code)


func do_clear() -> void:
	vfx_rect.visible = not vfx_rect.visible


func do_hocuspocus() -> void:
	var vfx := preload("res://cheat/hocus_pocus_vfx.tscn").instantiate() as CPUParticles2D
	vfx.one_shot = true
	vfx.emitting = true
	var player := GameManager.player
	player.add_sibling(vfx)
	# center where player is looking
	vfx.position = player.position + 30.0 * Vector2.from_angle(player.interact_sensor.rotation)
	vfx.position.y -= 10.0
	await get_tree().create_timer(vfx.lifetime * 2.0).timeout
	# remove the particle system once it's done being used
	vfx.queue_free()


func do_pspspsps() -> void:
	GameManager.do_combat(EnemyGen.random_enemy())


func do_anypercent() -> void:
	GameManager.player.speed = 200.0


func do_openyoureyes() -> void:
	GameManager.overworld_size = Vector2(640.0, 360.0)
	GameManager.viewport.pixel_level_root.size_2d_override = GameManager.overworld_size


func do_dogmode() -> void:
	GameManager.dog_mode = not GameManager.dog_mode


func do_bite_mode() -> void:
	GameManager.bite_mode = not GameManager.bite_mode


func do_pyrious() -> void:
	GameManager.do_combat(load("res://overworld/npc/boss/muffin/muffin.tres"))
