class_name AttackPattern


## The projectile to spawn for each attack
var projectile: PackedScene
## The delay before the first attack
var delay: float
## The delay between consecutive attacks
var cooldown: float
## The remaining number of attacks before the attack pattern finishes
var remaining_attacks: int
## The center of the arena is (0, 0), and the corners are (+-1, +-1)
var position: Vector2
## The difference in position between two consecutive attacks
var position_step: Vector2
## The initial direction of the projectile (in radians)
var angle: float
## The difference in angle between two consecutive attacks
var angle_step: float
