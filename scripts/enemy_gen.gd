class_name EnemyGen


static func random_name() -> String:
	const FIRST_NAME_LIST: Array[String] = [
		"Bella",
		"Daisy",
		"Leo",
		"Luna",
		"Max",
		"Oliver",
	]
	const LAST_NAME_PREFIX_LIST: Array[String] = [
		"Cuddle",
		"Cutey",
		"Fluffy",
		"Grumpy",
		"Kitty",
		"McCat",
		"Silly",
		"Snicker",
		"Snuggle",
		"Tuna",
	]
	const LAST_NAME_SUFFIX_LIST: Array[String] = [
		"belly",
		"boots",
		"buns",
		"face",
		"paws",
		"puff",
		"tail",
	]
	const FULL_NAME_PATTERN := "{first} {last_prefix}{last_suffix}"
	
	return FULL_NAME_PATTERN.format({
		"first": FIRST_NAME_LIST.pick_random(),
		"last_prefix": LAST_NAME_PREFIX_LIST.pick_random(),
		"last_suffix": LAST_NAME_SUFFIX_LIST.pick_random(),
	})


static func random_portrait() -> Texture2D:
	const PORTRAIT_LIST: Array[Texture2D] = [
		preload("res://assets/combat/mutant1.png"),
	]
	
	return PORTRAIT_LIST.pick_random()


# Return: [bg, bg_overlay]
static func random_colors() -> Array:
	# Each item: [bg, bg_overlay]
	const ENEMY_COLORS_LIST := [
		[Color.RED, Color.BLUE],
	]
	
	return ENEMY_COLORS_LIST.pick_random()


static func random_attack_phases() -> Array[AttackPhase]:
	const ATTACK_PHASE_LIST: Array[AttackPhase] = [
		preload("res://assets/resources/combat/phases/yarn_skip_x.tres"),
	]
	const NUM_PHASES: int = 8
	const DELAY_BETWEEN_PHASES := 8.0
	const INITIAL_DELAY := 0.5
	
	var phases: Array[AttackPhase]
	var delay := INITIAL_DELAY
	for _i in NUM_PHASES:
		var phase := ATTACK_PHASE_LIST.pick_random().duplicate() as AttackPhase
		phase.delay = delay
		delay += DELAY_BETWEEN_PHASES
		phases.append(phase)
	
	return phases


static func random_loot() -> Inventory:
	const ENEMY_LOOT_LIST: Array[Item] = [
		preload("res://assets/resources/items/ItemCanTuna.tres"),
		preload("res://assets/resources/items/ItemCatnip.tres"),
		preload("res://assets/resources/items/ItemCucumber.tres"),
		preload("res://assets/resources/items/ItemSprayBottle.tres"),
	]
	const ENEMY_LOOT_CHANCE := 0.5
	
	var inventory := Inventory.new()
	if randf() < ENEMY_LOOT_CHANCE:
		inventory.add_item(ENEMY_LOOT_LIST.pick_random())
	return inventory


static func random_win_dialog() -> DialogData:
	return null


static func random_lose_dialog() -> DialogData:
	return null


static func random_enemy() -> Enemy:
	var enemy := Enemy.new()
	
	# Appearance
	enemy.name = random_name()
	var colors := random_colors()
	# TODO: Apply random colors to portrait?
	enemy.portrait = random_portrait()
	enemy.bg_color = colors[0]
	enemy.bg_overlay_color = colors[1]
	
	# Fight
	enemy.exhaustion_cooldown = randf_range(0.4, 0.6)
	enemy.max_exhaustion = randi_range(1, 3) * 8.0 / enemy.exhaustion_cooldown
	enemy.max_suspicion = randf_range(2.0, 6.0)
	enemy.attack_phases = random_attack_phases()
	
	# Results
	enemy.win_loot = random_loot()
	enemy.win_dialog = random_win_dialog()
	enemy.lose_dialog = random_lose_dialog()
	
	return enemy
