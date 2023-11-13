extends Node2D


var fight: Fight


func _ready() -> void:
	print("Fighting ", fight.enemy_name)
	$DurationTimer.start(fight.duration)
	
	for pattern_idx in fight.attack_patterns.size():
		var pattern: AttackPattern = fight.attack_patterns[pattern_idx]
		var cooldown_timer := Timer.new()
		add_child(cooldown_timer)
		cooldown_timer.timeout.connect(attack.bind(pattern_idx))
		cooldown_timer.start(pattern.delay)
		cooldown_timer.wait_time = pattern.cooldown


func attack(pattern_idx: int) -> void:
	var pattern: AttackPattern = fight.attack_patterns[pattern_idx]
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


func _on_duration_timer_timeout() -> void:
	# TODO: Player wins!
	GameManager.exit_combat()
