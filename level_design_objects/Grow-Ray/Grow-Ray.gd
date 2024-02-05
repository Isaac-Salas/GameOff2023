extends Node3D
@export var target_size = 2.5
signal shrink_player(target_size)

@onready var shrink_ray = $RayCast3D

func _process(_delta):
	if shrink_ray.is_colliding():
		var collider = shrink_ray.get_collider()
		match collider.name:
			'Player':
				$"../Player"._on_ray_collided(target_size)
			
