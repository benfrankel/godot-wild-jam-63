extends Node2D

@export var victory_scene : PackedScene

var enemy: Enemy
var exhaustion: int = 0
var suspicion: int = 0
@onready var laser := %Laser as Laser
@onready var exh_meter := $Hud/ExhSus/ExhSusMeter/ExhMeter as ProgressBar
@onready var sus_meter := $Hud/ExhSus/ExhSusMeter/SusMeter as ProgressBar


func _ready() -> void:
	$Hud/EnemyName.text = enemy.name
	$Background.self_modulate = enemy.bg_color
	$BackgroundOverlay.self_modulate = enemy.bg_overlay_color
	$EnemyPortrait.texture = enemy.portrait
	$ExhaustionTimer.start(enemy.exhaustion_cooldown)
	exh_meter.max_value = enemy.max_exhaustion
	sus_meter.max_value = enemy.max_suspicion
	for phase in enemy.attack_phases:
		launch_phase(phase)


func launch_phase(phase: AttackPhase) -> void:
	# Apply phase settings to each pattern
	var arena: Rect2 = get_global_arena_rect()
	for pattern in phase.patterns:
		pattern.position = pattern.position.rotated(phase.rotation) * phase.scale + phase.position
		pattern.position = arena.get_center() + pattern.position * arena.size / 2.0
		pattern.position_step = pattern.position_step.rotated(phase.rotation) * phase.scale
		pattern.position_step *= arena.size / 2.0
		pattern.rotation += phase.rotation
		pattern.scale *= phase.scale
	
	# Wait on delay
	if phase.delay > 0.0:
		await get_tree().create_timer(phase.delay, false).timeout
	
	for _i in phase.count:
		# Launch patterns
		for pattern in phase.patterns:
			launch_pattern(pattern.duplicate())
		
		# Wait on cooldown
		if phase.cooldown > 0.0:
			await get_tree().create_timer(phase.cooldown, false).timeout


func launch_pattern(pattern: AttackPattern) -> void:
	# Wait on delay
	if pattern.delay > 0.0:
		await get_tree().create_timer(pattern.delay, false).timeout
	
	for _i in pattern.count:
		# Spawn projectile
		var projectile := pattern.projectile.instantiate() as Projectile
		projectile.laser = laser
		projectile.spawn_time = pattern.spawn_time
		projectile.lifetime = pattern.lifetime
		projectile.despawn_time = pattern.despawn_time
		projectile.global_position = pattern.position
		projectile.rotation = deg_to_rad(pattern.rotation)
		projectile.custom_set_scale(pattern.scale)
		projectile.linear_velocity = pattern.speed * Vector2.from_angle(deg_to_rad(pattern.angle))
		projectile.angular_velocity = deg_to_rad(pattern.angular_velocity)
		$Projectiles.add_child(projectile)
		
		# Step pattern
		pattern.position += pattern.position_step
		pattern.rotation += pattern.rotation_step
		pattern.scale *= pattern.scale_step
		pattern.angle += pattern.angle_step
		
		# Wait on cooldown
		if pattern.cooldown > 0.0:
			await get_tree().create_timer(pattern.cooldown, false).timeout


func get_global_arena_rect() -> Rect2:
	var arena: Rect2 = ($Arena/Bounds.shape as RectangleShape2D).get_rect()
	arena.position += $Arena/Bounds.global_position
	return arena


func finish(win: bool) -> void:
	# TODO: Handle win / loss
	print("Combat over! Win? ", win)
	if win:
		var v :VictoryScreen = victory_scene.instantiate()
		GameManager.viewport.hi_res_gui_root.add_child(v)
		v.load_from(enemy)
	GameManager.exit_combat()


func _on_exhaustion_timer_timeout() -> void:
	exhaustion += 1
	exh_meter.value = exhaustion
	if exhaustion >= enemy.max_exhaustion:
		finish(true)


func _on_laser_got_hit(_projectile: Projectile) -> void:
	suspicion += 1
	sus_meter.value = suspicion
	if suspicion >= enemy.max_suspicion:
		finish(false)
