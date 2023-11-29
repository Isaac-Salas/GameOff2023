extends CharacterBody3D
var player
var SPEED
var Playerclose
var reached 
var change
var switch = 1
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite3D.play("Idle")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Playerclose == true:
		start()
		if change == true:
			tracking()
			matchtest()
			

func matchtest():
	match switch:
		0:
			print("En ceros")
			
		1:
			$AnimatedSprite3D.play("Turn")
			await $AnimatedSprite3D.animation_finished
			switch = 2
		2:
			$AnimatedSprite3D.play("Turned-Idle")
			await $AnimatedSprite3D.animation_finished
			switch = 3
		3:
			$AnimatedSprite3D.play("Scream")
			await $AnimatedSprite3D.animation_finished
			change = true
			switch = 4
		4:
			$AnimatedSprite3D.play("Run")
			
		5: 
			$AnimatedSprite3D.play("Catch")
			await $AnimatedSprite3D.animation_finished
			change = true
			switch = 4
func start():
	matchtest()



func tracking():
	SPEED=player.startspeed
	update_target(player.global_transform.origin)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()
	
func loadPlayer():
	player = get_node(player_path)

func update_target(target_position):
	nav_agent.target_position = target_position


func _on_navigation_agent_3d_target_reached():
	switch = 5

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		Playerclose = true
		switch = 1
		$Area3D.queue_free()
