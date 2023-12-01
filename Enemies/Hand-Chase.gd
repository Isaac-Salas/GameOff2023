extends CharacterBody3D
var player
var SPEED
var Playerclose
var reached 
var change
var switch = 1
var camera
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@export var target_size = 1.5
@onready var new = preload("res://level_design_objects/Obstacles.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.target_scale = target_size
	$AnimatedSprite3D.play("Idle")
	move_and_slide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Playerclose == true:
		start()
		if change == true:
			if camera.size < 80:
				camera.size += 0.5
			tracking()
			matchtest()
			

func matchtest():
	match switch:
		0:
			#print("En ceros")
			pass
			
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
			get_tree().set_pause(false)
			change = true
			switch = 4
		4:
			$AnimatedSprite3D.play("Run")
			
		5: 
			$AnimatedSprite3D.play("Catch")
			await $AnimatedSprite3D.animation_finished
			switch = 4
		6:
			player.goo()
			$AnimatedSprite3D.play("Catch")
			$AnimationPlayer.play("Punch test")
			player.hit(GlobalVar.target_scale)
			player.velocity.x = 2.5*(SPEED)
			player.velocity.y = 0.1*(SPEED)
			await $AnimationPlayer.animation_finished
			switch = 4
		10:
			pass



func start():
	camera = get_parent_node_3d().find_child("F-Camera")
	matchtest()

func tracking():
	loadPlayer()
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
	pass

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		get_tree().set_pause(true)
		player.startspeed = 40
		player.find_child("PlayerRigid").set_linear_velocity(Vector3(30,10,10))
		Playerclose = true
		switch = 1
		$"../Beginlights".queue_free()
		$"../Hand-lights".queue_free()
		$"../Red-Light".queue_free()
		$"../Repisa-Tubes".queue_free()
		$Area3D.queue_free()
		get_parent_node_3d().add_child(new.instantiate())



func _on_playerthrow_body_entered(body):
	#print(body.name)
	if body.name == "Player":
		GlobalVar.target_scale -= 0.5
		await $AnimatedSprite3D.animation_looped
		switch = 6
		



func _on_area_3d_body_exited(body):
	pass
