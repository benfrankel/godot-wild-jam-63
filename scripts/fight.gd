class_name Fight
extends Resource


## The name of the enemy the player is fighting
@export var enemy_name := ""
## Duration of the fight (in seconds), after which the player wins
@export var duration := 60.0
## The attack patterns that spawn projectiles during the fight
@export var attack_patterns: Array[AttackPattern]
