extends Node2D
class_name Combat

const ITEM_ENTRY_SCENE := preload("res://combat/gui/item_entry.tscn") as PackedScene
const MAFIA_MUSIC := preload("res://assets/audio/compos/song3.wav") as AudioStreamWAV

@export var enemy: Enemy # exporting to allow quick testing
var state := CombatState.new()
var item_entries: Array[CombatItemEntry]
@onready var laser := %Laser as Laser
@onready var exh_meter := $Hud/ExhSus/ExhSusMeter/ExhMeter as ProgressBar
@onready var sus_meter := $Hud/ExhSus/ExhSusMeter/SusMeter as ProgressBar

signal player_damaged


func _ready() -> void:
	if enemy.win_dialog and not enemy.win_dialog.character_name:
		enemy.win_dialog.character_name = enemy.name
	if enemy.lose_dialog and not enemy.lose_dialog.character_name:
		enemy.lose_dialog.character_name = enemy.name
	
	# Set up CombatState
	state.projectiles_root = $Projectiles
	state.enemy = enemy
	state.changed.connect(_on_state_change)
	
	# Set up nodes
	$Background.self_modulate = enemy.bg_color
	$BackgroundOverlay.self_modulate = enemy.bg_overlay_color
	$EnemyPortrait.texture = enemy.portrait
	$Hud/EnemyName.text = enemy.name
	exh_meter.max_value = enemy.max_exhaustion
	sus_meter.max_value = enemy.max_suspicion
	$ExhaustionTimer.start(enemy.exhaustion_cooldown)
	for idx in GameManager.player_inventory.items.size():
		var item_entry := ITEM_ENTRY_SCENE.instantiate() as CombatItemEntry
		item_entry.slot = idx
		item_entry.combat_state = state
		var container := $Hud/Inventory/InventoryL if idx < 5 else $Hud/Inventory/InventoryR
		container.add_child(item_entry)
		if idx == 0:
			item_entry.grab_focus()
		elif idx != 5:
			var top := container.get_child(idx % 5 - 1) as CombatItemEntry
			top.focus_neighbor_bottom = item_entry.get_path()
			item_entry.focus_neighbor_top = top.get_path()
		item_entry.update()
		item_entries.append(item_entry)
	
	# Launch attack phases
	for phase in enemy.attack_phases:
		# Work-around for https://github.com/godotengine/godot/issues/74918
		var dupe_phase := phase.duplicate(true)
		for i in dupe_phase.patterns.size():
			dupe_phase.patterns[i] = dupe_phase.patterns[i].duplicate(true)
		launch_phase(dupe_phase)


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return

	var item_entry := item_entries.pop_back() as CombatItemEntry
	if not item_entry:
		return

	item_entry.queue_free()
	if item_entries.is_empty():
		return

	item_entries[-1].focus_neighbor_bottom = ""
	if not item_entry.has_focus():
		return

	item_entries[-1].grab_focus()


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
			pattern.angle_step *= flip.x * flip.y
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
			if not projectile:
				push_error("projectile scenes must extend or use class `Projectile`")
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


static func finish(enemy_: Enemy, win: bool) -> void:
	await GameManager.exit_combat(win)
	if win:
		await GameManager.do_dialog(Dialog.create_dialog(enemy_.win_dialog))
		if enemy_.win_loot and (enemy_.win_loot.items or enemy_.win_loot.boss_items):
			await GameManager.viewport.do_loot_screen(LootScreen.create(enemy_.win_loot))
		
	else:
		GameManager.do_dialog(Dialog.create_dialog(enemy_.lose_dialog))


func _on_exhaustion_timer_timeout() -> void:
	state.exhaustion += 1
	state.emit_changed()


func _on_laser_got_hit(_projectile: Projectile) -> void:
	state.suspicion += 1
	state.emit_changed()
	player_damaged.emit()

func _on_state_change() -> void:
	exh_meter.value = state.exhaustion
	if state.exhaustion >= enemy.max_exhaustion:
		Combat.finish(enemy, true)
	sus_meter.value = state.suspicion
	if state.suspicion >= enemy.max_suspicion:
		Combat.finish(enemy, false)
