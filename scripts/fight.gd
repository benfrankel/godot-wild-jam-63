class_name Fight
extends Resource


## The name of the enemy the player is fighting.
@export var enemy_name := ""
## Max exhaustion the enemy can reach before they give up (player wins).
@export var max_exhaustion: int = 10
## The time it takes for the enemy to gain 1 exhaustion.
@export var exhaustion_cooldown := 5.0
## Max suspicion the enemy can reach before they figure out what's going on (player loses).
@export var max_suspicion: int = 10
## The attack patterns that spawn projectiles during the fight.
@export var attack_patterns: Array[AttackPattern]
