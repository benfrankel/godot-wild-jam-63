extends Projectile


const SHARD_SCENES: Array[PackedScene] = [
	preload("res://scenes/combat/projectile/glass_cup_M_shard1.tscn"),
	preload("res://scenes/combat/projectile/glass_cup_M_shard2.tscn"),
	preload("res://scenes/combat/projectile/glass_cup_M_shard3.tscn"),
	preload("res://scenes/combat/projectile/glass_cup_M_shard4.tscn"),
	preload("res://scenes/combat/projectile/glass_cup_M_shard5.tscn"),
]


func _on_body_entered(_body: Node) -> void:
	for shard_scene in SHARD_SCENES:
		var shard := shard_scene.instantiate() as Projectile
		shard.lifetime = 1.0
		shard.transform = transform
		shard.linear_velocity = Vector2(randf_range(-100.0, 100.0), randf_range(-300.0, -50.0))
		shard.angular_velocity = randf_range(-PI, PI)
		call_deferred("add_sibling", shard)
	
	queue_free()
