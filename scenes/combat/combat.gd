extends Node2D


var enemy: Enemy
var exhaustion: int = 0
var suspicion: int = 0


func _ready() -> void:
	print("Fighting ", enemy.name)
	$ExhaustionTimer.start(enemy.exhaustion_cooldown)
	
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
	projectile.angle = pattern.angle
	var arena: Rect2 = get_global_arena_rect()
	projectile.global_position = arena.get_center() + pattern.position * arena.size / 2.0
	$Projectiles.add_child(projectile)
	
	pattern.angle += pattern.angle_step
	pattern.position += pattern.position_step
	pattern.remaining_attacks -= 1


func get_global_arena_rect() -> Rect2:
	var arena: Rect2 = ($Arena/Bounds.shape as RectangleShape2D).get_rect()
	arena.position += $Arena/Bounds.global_position
	return arena


func finish(win: bool) -> void:
	# TODO: Handle win / loss
	print("Combat over! Win? ", win)
	GameManager.exit_combat()


func _on_exhaustion_timer_timeout() -> void:
	exhaustion += 1
	# TODO: Update UI
	print("Exhaustion is now ", exhaustion, " / ", enemy.max_exhaustion)
	if exhaustion >= enemy.max_exhaustion:
		finish(true)


func _on_laser_got_hit(_projectile: Projectile) -> void:
	suspicion += 1
	# TODO: Update UI
	print("Suspicion is now ", suspicion, " / ", enemy.max_suspicion)
	if suspicion >= enemy.max_suspicion:
		finish(false)
