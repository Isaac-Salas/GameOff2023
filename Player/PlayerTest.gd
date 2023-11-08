extends CharacterBody3D

var pickup
var pickupinst = preload("res://Pickups/PickObject.tscn")
var pickinst = pickupinst.instantiate()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	position.z == 0
	var pos = get_node(".").position
	#Updating the label
	#print(GlobalVar.sizefactor)
	if GlobalVar.sizefactor>=1.5:
		GlobalVar.CURRENT = "BIG"
	if GlobalVar.sizefactor<=0.5:
		GlobalVar.CURRENT = "SMALL"
	if GlobalVar.sizefactor==1:
		GlobalVar.CURRENT = "NORMAL"
		GlobalVar.SPEED= 10
		GlobalVar.JUMP_VELOCITY = 20
	
	
	#Peruvian Scaling
	if Input.is_key_pressed(KEY_Z):
		#print (scale)
		#Upscaling until sizefactor <2
		if GlobalVar.pick == "UP" and GlobalVar.sizefactor <= 2:
			get_node("MeshInstance3D").scale += Vector3(0.01,0.01,0)
			get_node("CollisionShape3D").scale += Vector3(0.01,0.01,0)
			get_node("ColisionperuanaDer2").position.x += 0.01
			get_node("ColisionperuanaIzq").position.x -= 0.01
			get_node("ColisionArriba").position.y += 0.01
			
			get_node("ColisionperuanaDer2").scale.y += 0.01
			get_node("ColisionperuanaIzq").scale.y += 0.01
			get_node("ColisionArriba").scale.x += 0.01
			
			get_node("ColisionperuanaDer2").position.y = 0
			get_node("ColisionperuanaIzq").position.y = 0
			GlobalVar.sizeM = get_node("CollisionShape3D").scale
			GlobalVar.sizefactor = GlobalVar.sizeM.x
			GlobalVar.state = "growing"
			GlobalVar.ProgBar += 0.01 
			
			if GlobalVar.CURRENT == "SMALL":
				GlobalVar.SPEED -= (9*delta)
				GlobalVar.JUMP_VELOCITY -= (9*delta)
				print("Velocidad: ", GlobalVar.SPEED)
				print("VelocidadSaltp: ", GlobalVar.JUMP_VELOCITY)
		
		#Downscaling until sizefactor <2
		if GlobalVar.pick == "DOWN" and GlobalVar.sizefactor >= 0.1:
			
			if GlobalVar.CURRENT == "SMALL":
				GlobalVar.SPEED += (20*delta)
				GlobalVar.JUMP_VELOCITY += (20*delta)
				print(GlobalVar.SPEED)
				print(GlobalVar.JUMP_VELOCITY)
			
			get_node("MeshInstance3D").scale -= Vector3(0.01,0.01,0)
			get_node("CollisionShape3D").scale -= Vector3(0.01,0.01,0)
			get_node("ColisionperuanaDer2").position.x -= 0.01
			get_node("ColisionperuanaIzq").position.x += 0.01
			get_node("ColisionArriba").position.y -= 0.01
			
			get_node("ColisionperuanaDer2").scale.y -= 0.01
			get_node("ColisionperuanaIzq").scale.y -= 0.01
			get_node("ColisionArriba").scale.x -= 0.01
			
			get_node("ColisionperuanaDer2").position.y = 0
			get_node("ColisionperuanaIzq").position.y = 0
			GlobalVar.sizeM = get_node("CollisionShape3D").scale
			GlobalVar.sizefactor = GlobalVar.sizeM.x
			GlobalVar.state = "shrinking"
	
	#When its not being scaled
	else:
		GlobalVar.state = "static"
	
	
	if Input.is_key_pressed(KEY_X):
		if GlobalVar.pick == "small":
			GlobalVar.pick = "big"
	
	if Input.is_key_pressed(KEY_C):
		if GlobalVar.pick == "big":
			GlobalVar.pick = "small"
		
		
	# Add the gravity.
	if not is_on_floor():                     
		velocity.y -= (gravity*4) * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = GlobalVar.JUMP_VELOCITY
		if GlobalVar.sizefactor>3:
			velocity.y = GlobalVar.JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with ass gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y,0)).normalized()
	
	#-------------------------------------------------------------------------------------------------------
	#Perfect example of peruvian solutions c:
	if direction:
		velocity.x = direction.x * (GlobalVar.SPEED)
		velocity.z = 0
	else:
		velocity.x = move_toward(velocity.x, 0, (GlobalVar.SPEED))
		velocity.z = 0
		
	if Input.is_key_pressed(KEY_X) and pickup == true:
		
		print(pos)
	
		pickinst.transform.origin = (Vector3(0,2,0))
		pickinst.get_node("Pickup").freeze = true
		pickinst.get_node("Pickup/Area3D").monitoring = false
		add_child(pickinst)
	if Input.is_key_pressed(KEY_X):
		pickinst.get_node("Pickup").freeze = false
		
		
	move_and_slide()




func _on_object_detect_body_entered(body):
	if body.name == "Pickup":
		print("Assin")
		pickup = true



func _on_object_detect_body_exited(body):
	if body.name == "Pickup":
		print("Assout")
		pickup = false
