class_name AttackPhase
extends Resource


## The delay before the phase starts (in seconds)
@export var delay := 0.0
## The cooldown before the phase repeats (in seconds)
@export var cooldown := 1.0
## The number of iterations before the phase finishes
@export var count: int = 1
## The position of the phase (center of the arena is (0, 0), corners are (+-1, +-1))
@export var position := Vector2.ZERO
## The change in position per iteration
@export var position_step := Vector2.ZERO
## The rotation of the phase (in degrees)
@export var rotation := 0.0
## The change in rotation per iteration
@export var rotation_step := 0.0
## The scale of the phase
@export var scale := Vector2.ONE
## The multiplier to scale per iteration
@export var scale_step := Vector2.ONE
## The attack patterns that play out during the phase
@export var patterns: Array[AttackPattern] = []
