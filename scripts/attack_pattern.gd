class_name AttackPattern
extends Resource


## The projectile to spawn for each attack
@export var projectile: PackedScene
## The delay before the first attack
@export var delay := 0.0
## The delay between consecutive attacks
@export var cooldown := 1.0
## The remaining number of attacks before the attack pattern finishes
@export var remaining_attacks: int = 1
## The center of the arena is (0, 0), and the corners are (+-1, +-1)
@export var position: Vector2
## The difference in position between two consecutive attacks
@export var position_step: Vector2
## The initial direction of the projectile (in radians)
@export_range(0.0, TAU) var angle: float
## The difference in angle between two consecutive attacks
@export_range(0.0, TAU) var angle_step: float
