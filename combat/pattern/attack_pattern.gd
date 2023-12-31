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
## An attack to skip (by index, negative for no skip)
@export var skip: int = -1
## The change in skip per launch of this pattern (wraps around)
@export var skip_step: int = 0
## The number of attacks to be randomly skipped
@export var random_skips: int = 0
## The spawn time of the projectile (in seconds)
@export var spawn_time := 0.5
## The lifetime of the projectile (in seconds)
@export var lifetime := 5.0
## The despawn time of the projectile (in seconds)
@export var despawn_time := 0.5
## The initial position of the projectile (center of the arena is (0, 0), corners are (+-1, +-1))
@export var position := Vector2.ZERO
## The change in position between attacks
@export var position_step := Vector2.ZERO
## The initial rotation of the projectile (in degrees)
@export var rotation := 0.0
## The change in rotation between attacks
@export var rotation_step := 0.0
## The initial scale of the projectile
@export var scale := Vector2.ONE
## The multiplier to scale between attacks
@export var scale_step := Vector2.ONE
## The initial speed of the projectile
@export var speed := 300.0
## The initial direction of the projectile (as an angle, in degrees)
@export var angle := 0.0
## The change in angle between attacks
@export var angle_step := 0.0
## The initial angular velocity of the projectile (in degrees per second)
@export var angular_velocity := 0.0
