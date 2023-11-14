class_name Enemy
extends Resource


## Name of the enemy.
@export var name := ""
## Max exhaustion the enemy can reach before they give up (player wins).
@export var max_exhaustion: int = 10
## Time it takes for the enemy to gain 1 exhaustion.
@export var exhaustion_cooldown := 5.0
## Max suspicion the enemy can reach before they realize what's going on (player loses).
@export var max_suspicion: int = 10
## Projectile spawning patterns during the fight.
@export var attack_patterns: Array[AttackPattern]
