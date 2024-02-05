extends CharacterBody3D
var player
var hamster
var SPEED
@onready var Playerclose = false

@onready var change = false
@onready var switch = 1
var camera
var index
@onready var go = 0
@onready var thing = true
@export var player_path : NodePath
@export var hamster_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@export var target_size = 1.5
@onready var new = preload("res://level_design_objects/Obstacles.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	#DialogManager.current_line_index = 0
	hamster = get_node(hamster_path)
	GlobalVar.target_scale = target_size
	$AnimatedSprite3D.play("Idle")
	move_and_slide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	index = DialogManager.current_line_index
	#print(index)
	
	if thing == true:
		match index:
			0:
				pass
			1:
				pass
			2:
				pass
			
			3:
				match go:
					0:
						startup()
						go = 1
					1:
						pass
					2:
						pass
			4:
				DialogManager.loaded_box = "res://UI/TextBox/Bigger.tscn"
			5:
				switch = 4
				go=2
				
				
#				go = 1
#		match go:
#			0:
#				startup()
#				go = 1
#			1:
#				match index:
#					2:
#						switch = 4
#						go = 2
#			2:
#				pass
#
	if Playerclose == true:
		start()
		if change == true:
			if camera.size < 80:
				camera.size += 1
				#print(camera.size)
				
			if go == 2:
				tracking()
				#DialogManager.text_box.size = DialogManager.text_box.size*2
				
				
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
			change = true
			switch = "Interlude"
			
		"Interlude":
			$AnimatedSprite3D.play("Turned-Idle")
			await $AnimatedSprite3D.animation_finished
			get_tree().set_pause(false)
			
		
		4:
			$AnimatedSprite3D.play("Run")
			hamster.run()
			
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
	SPEED= 35
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



func startup():
		get_tree().set_pause(true)
		player.startspeed = 40
		player.find_child("PlayerRigid").set_linear_velocity(Vector3(30,10,10))
		Playerclose = true
		switch = 1
		$"../Beginlights".queue_free()
		$"../Hand-lights".queue_free()
		$"../Red-Light".queue_free()
		$"../Repisa-Tubes".queue_free()
		$"../Scattered".queue_free()
		#$Area3D.queue_free()
		get_parent_node_3d().add_child(new.instantiate())


func _on_playerthrow_body_entered(body):
	if body.name == "Player":
		#print(body.name)
		GlobalVar.target_scale -= 0.5
		await $AnimatedSprite3D.animation_looped
		switch = 6
		



