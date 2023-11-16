extends Node2D

@export var victory_scene : PackedScene
@export var enemy: Enemy # exporting to allow quick testing
@export var inventory_scene : PackedScene

var exhaustion: int = 0
var suspicion: int = 0
var inventory : Control
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
	inventory = inventory_scene.instantiate()
	GameManager.viewport.hi_res_gui_root.add_child(inventory)
	
	for phase in enemy.attack_phases:
		# Work-around for https://github.com/godotengine/godot/issues/74918
		var dupe_phase := phase.duplicate(true)
		for i in dupe_phase.patterns.size():
			dupe_phase.patterns[i] = dupe_phase.patterns[i].duplicate(true)
		launch_phase(dupe_phase)


func launch_phase(phase: AttackPhase) -> void:
	# Wait on delay
	if phase.delay > 0.0:
		await get_tree().create_timer(phase.delay, false).timeout
	
	for _i in phase.count:
		# Launch patterns
		var arena: Rect2 = get_global_arena_rect()
		for pattern in phase.patterns:
			pattern = pattern.duplicate()
			pattern.position = pattern.position.rotated(phase.rotation) * phase.scale + phase.position
			pattern.position = arena.get_center() + pattern.position * arena.size / 2.0
			pattern.position_step = pattern.position_step.rotated(phase.rotation) * phase.scale
			pattern.position_step *= arena.size / 2.0
			pattern.rotation += phase.rotation
			pattern.scale *= phase.scale
			var flip := phase.scale.sign()
			pattern.angle *= flip.x * flip.y
			if flip.x < 0.0:
				pattern.angle += 180.0
			launch_pattern(pattern)
			
		# Step phase
		for pattern in phase.patterns:
			pattern.skip += pattern.skip_step
		phase.position += phase.position_step
		phase.rotation += phase.rotation_step
		phase.scale *= phase.scale_step
		
		# Wait on cooldown
		if phase.cooldown > 0.0:
			await get_tree().create_timer(phase.cooldown, false).timeout


func launch_pattern(pattern: AttackPattern) -> void:
	# Wait on delay
	if pattern.delay > 0.0:
		await get_tree().create_timer(pattern.delay, false).timeout
	
	# Remove skips
	var idxs := range(pattern.count)
	if pattern.skip >= 0:
		pattern.skip %= pattern.count
		idxs.erase(pattern.skip)
	if not idxs:
		return
	for _i in pattern.random_skips:
		idxs.remove_at(randi() % idxs.size())
		if not idxs:
			return
	
	for i in pattern.count:
		# Spawn projectile
		if i in idxs:
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
	if win:
		var v :VictoryScreen = victory_scene.instantiate()
		GameManager.viewport.hi_res_gui_root.add_child(v)
		v.load_from(enemy)
	inventory.queue_free()
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
