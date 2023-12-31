class_name Enemy
extends Resource


@export_group("Appearance")
## Name of the enemy.
@export var name := ""
## Is the enemy in the mafia?
@export var is_mafia := false
## Portrait of the enemy.
@export var portrait: Texture2D
## Color of the combat background.
@export_color_no_alpha var bg_color := Color.BLACK
## Color of the pattern overlay on the combat background.
@export_color_no_alpha var bg_overlay_color := Color.BLACK

@export_group("Fight")
## Max exhaustion the enemy can reach before they give up (player wins).
@export var max_exhaustion := 20.0
## Time it takes for the enemy to gain 1 exhaustion.
@export var exhaustion_cooldown := 0.5
## Max suspicion the enemy can reach before they realize what's going on (player loses).
@export var max_suspicion := 8.0
## Attack phases that play out during the combat.
@export var attack_phases: Array[AttackPhase]

@export_group("Results")
## The loot that the player gets after winning (optional).
@export var win_loot: Inventory
## The dialog to play after victory (optional).
@export var win_dialog: DialogData
## The dialog to play after defeat (optional).
@export var lose_dialog: DialogData
