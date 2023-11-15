extends Node2D

@export var victory_scene : PackedScene

var enemy: Enemy
var exhaustion: int = 0
var suspicion: int = 0
@onready var laser := %Laser as Laser
@onready var exh_meter := $ExhSus/ExhSusMeter/ExhMeter as ProgressBar
@onready var sus_meter := $ExhSus/ExhSusMeter/SusMeter as ProgressBar


func _ready() -> void:
	print("Fighting ", enemy.name)
	$Background.self_modulate = enemy.bg_color
	$BackgroundOverlay.self_modulate = enemy.bg_overlay_color
	$EnemyPortrait.texture = enemy.portrait
	$ExhaustionTimer.start(enemy.exhaustion_cooldown)
	exh_meter.max_value = enemy.max_exhaustion
	sus_meter.max_value = enemy.max_suspicion
	
	for pattern_idx in enemy.attack_patterns.size():
		var pattern: AttackPattern = enemy.attack_patterns[pattern_idx]
		var cooldown_timer := Timer.new()
		add_child(cooldown_timer)
		cooldown_timer.timeout.connect(attack.bind(pattern_idx))
		cooldown_timer.start(pattern.delay)
		cooldown_timer.wait_time = pattern.cooldown


func attack(pattern_idx: int) -> void:
	var pattern: AttackPattern = enemy.attack_patterns[pattern_idx]
	if pattern.remaining_attacks <= 0:
		return
	
	var projectile := pattern.projectile.instantiate() as Projectile
	projectile.laser = laser
	projectile.lifetime = pattern.lifetime
	var arena: Rect2 = get_global_arena_rect()
	projectile.global_position = arena.get_center() + pattern.position * arena.size / 2.0
	projectile.rotation = deg_to_rad(pattern.rotation)
	projectile.custom_set_scale(pattern.scale)
	projectile.linear_velocity = pattern.speed * Vector2.from_angle(deg_to_rad(pattern.angle))
	projectile.angular_velocity = deg_to_rad(pattern.angular_velocity)
	$Projectiles.add_child(projectile)
	
	pattern.position += pattern.position_step
	pattern.rotation += pattern.rotation_step
	pattern.scale *= pattern.scale_step
	pattern.angle += pattern.angle_step
	pattern.remaining_attacks -= 1


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
