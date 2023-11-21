class_name CombatState
extends Resource
## Resources passed by reference means disparate functions can 
## modify this data without needing to constantly calling update 
## functions back and forth

var exhaustion: int = 0
var suspicion: int = 0
var projectiles_root: Node
var enemy: Enemy
