class_name Projectile
extends Area2D


@export
var damage := 1.0

@export_range(0.0, 2000.0)
var speed := 800.0
@export_range(0.0, TAU)
var angle := 0.0


func _process(delta: float):
	var direction := Vector2.from_angle(self.angle)
	var velocity := self.speed * direction
	self.position += delta * velocity


func _on_body_entered(body: Node2D):
	if body is Player:
		self.hit_player(body)
		
		
func hit_player(player: Player):
	self.queue_free()
	player.take_damage(self.damage)
