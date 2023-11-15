class_name AttackPattern
extends Resource


## The projectile to spawn for each attack
@export var projectile: PackedScene
## The delay before the attack starts (in seconds)
@export var delay := 0.0
## The cooldown between the attack repeats (in seconds)
@export var cooldown := 1.0
## The number of iterations before the pattern finishes
@export var count: int = 1
## The spawn time of the projectile (in seconds)
@export var spawn_time := 0.5
## The lifetime of the projectile (in seconds)
@export var lifetime := 5.0
## The despawn time of the projectile (in seconds)
@export var despawn_time := 0.5
## The initial position of the projectile (center of the arena is (0, 0), corners are (+-1, +-1))
@export var position: Vector2
## The difference in initial position between consecutive attacks
@export var position_step: Vector2
## The initial rotation of the projectile (in degrees)
@export var rotation := 0.0
## The difference in initial rotation between consecutive attacks (in degrees)
@export var rotation_step := 0.0
## The initial scale of the projectile
@export var scale := Vector2.ONE
## The multiplier for initial scale between consecutive attacks
@export var scale_step := Vector2.ONE
## The initial speed of the projectile
@export var speed := 300.0
## The initial direction of the projectile (as an angle, in degrees)
@export var angle := 0.0
## The difference in initial direction between consecutive attacks (as an angle, in degrees)
@export var angle_step := 0.0
## The initial angular velocity of the projectile (in degrees per second)
@export var angular_velocity := 0.0
