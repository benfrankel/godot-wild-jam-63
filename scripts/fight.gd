class_name Fight
extends Resource


## The name of the enemy the player is fighting
var enemy_name: String
## Duration of the fight, after which the player wins
var duration: float
## The attack patterns that spawn projectiles during the fight
var attack_patterns: Array[AttackPattern]
