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
		preload("res://overworld/encounter/mutant1.png"),
	]
	
	return PORTRAIT_LIST.pick_random()


# Return: [bg, bg_overlay]
static func random_colors() -> Array:
	# Each item: [bg, bg_overlay]
	const ENEMY_COLORS_LIST := [
		[Color("6e4b28"), Color("7c6132")],
		[Color("52453e"), Color("625b4f")],
		[Color("272a30"), Color("1f2229")],
	]
	const HUE_SHIFT_CHANCE := 0.3
	
	var colors := ENEMY_COLORS_LIST.pick_random().duplicate() as Array
	if randf() < HUE_SHIFT_CHANCE:
		var shift := randf()
		for i in colors.size():
			colors[i].h = fmod(colors[i].h + shift, 1.0)
	
	return colors


static func random_attack_phases() -> Array[AttackPhase]:
	const ATTACK_PHASE_LIST: Array[AttackPhase] = [
		preload("res://combat/phase/yarn_skip_x.tres"),
		preload("res://combat/phase/pounce.tres"),
	]
	const NUM_PHASES: int = 8
	const DELAY_BETWEEN_PHASES := 8.0
	const INITIAL_DELAY := 0.5
	
	var phases: Array[AttackPhase] = []
	var delay := INITIAL_DELAY
	for _i in NUM_PHASES:
		var phase := ATTACK_PHASE_LIST.pick_random().duplicate() as AttackPhase
		phase.delay = delay
		delay += DELAY_BETWEEN_PHASES
		phases.append(phase)
	
	return phases


static func random_loot() -> Inventory:
	const LOOT_LIST: Array[Item] = [
		preload("res://item/consumable/ItemCanTuna.tres"),
		preload("res://item/consumable/ItemCatnip.tres"),
		preload("res://item/consumable/ItemCucumber.tres"),
		preload("res://item/consumable/ItemSprayBottle.tres"),
	]
	const LOOT_CHANCE := 0.2
	const RARE_LOOT_LIST: Array[Item] = [
		preload("res://item/consumable/ItemMilk.tres"),
	]
	const RARE_LOOT_CHANCE := 0.05
	const LOOT_ATTEMPTS: int = 4
	
	var inventory := Inventory.new()
	for _i in LOOT_ATTEMPTS:
		if randf() < RARE_LOOT_CHANCE:
			inventory.add_item(RARE_LOOT_LIST.pick_random())
		elif randf() < LOOT_CHANCE:
			inventory.add_item(LOOT_LIST.pick_random())
	return inventory


static func random_win_dialog() -> DialogData:
	const LINES: Array[String] = [
		"Prrrrr... *falls asleep from exhaustion*",
		"Mew... *slinks away, looking defeated*",
		"Meow! *hastily retreats*",
	]
	
	var line := LINES.pick_random() as String
	var dialog := DialogData.new()
	dialog.lines = [line]
	
	return dialog


static func random_lose_dialog() -> DialogData:
	const LINES: Array[String] = [
		"Hissss! *leaves in frustration*",
		"... *glares at you menacingly*",
	]
	
	var line := LINES.pick_random() as String
	var dialog := DialogData.new()
	dialog.lines = [line]
	
	return dialog


static func random_enemy() -> Enemy:
	var enemy := Enemy.new()
	
	# Appearance
	enemy.name = random_name()
	enemy.portrait = random_portrait()
	var colors := random_colors()
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
