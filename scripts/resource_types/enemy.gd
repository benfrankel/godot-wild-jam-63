class_name Enemy
extends Resource


## Name of the enemy.
@export var name := ""
## Color of the combat background.
@export_color_no_alpha var bg_color := Color.BLACK
## Color of the pattern overlay on the combat background.
@export_color_no_alpha var bg_overlay_color := Color.BLACK
## Max exhaustion the enemy can reach before they give up (player wins).
@export var max_exhaustion: int = 10
## Time it takes for the enemy to gain 1 exhaustion.
@export var exhaustion_cooldown := 5.0
## Max suspicion the enemy can reach before they realize what's going on (player loses).
@export var max_suspicion: int = 10
## Projectile spawning patterns during the fight.
@export var attack_patterns: Array[AttackPattern]

@export_group("Combat Victory")
## the loot that the player gets after winning (optional)
@export var loot : Inventory

## the dialog to play after victory (optional)
@export var dialog : DialogData
