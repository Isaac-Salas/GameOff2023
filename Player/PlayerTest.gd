extends CharacterBody3D

var pos = get_node(".").position
var pickup
var pickupinst = preload("res://Pickups/PickObject.tscn")
var pickinst = pickupinst.instantiate()
var globalinst = pickupinst.instantiate()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rate = 0.02

func _input(event):
	if Input.is_key_pressed(KEY_V) and pickup == true:
		try_pickup()
	if Input.is_key_pressed(KEY_V) and pickup == false:
		release_pickup()


func _physics_process(delta):
	position.z == 0
	
	#Updating the label
	#print(GlobalVar.sizefactor)
	if GlobalVar.sizefactor>=1.5:
		GlobalVar.CURRENT = "BIG"
	if GlobalVar.sizefactor<=0.5:
		GlobalVar.CURRENT = "SMALL"
	if GlobalVar.sizefactor==1:
		GlobalVar.CURRENT = "NORMAL"

	if not GlobalVar.state == "static":
		GlobalVar.SPEED = 10/(0.5+GlobalVar.sizefactor)
		GlobalVar.JUMP_VELOCITY = 20/(0.5+GlobalVar.sizefactor)
		

	#Peruvian Scaling
	if Input.is_key_pressed(KEY_Z):
		#print (scale)
		
		#Upscaling until sizefactor <2
		if GlobalVar.pick == "UP":
			grow()
		
		#Downscaling until sizefactor <2
		if GlobalVar.pick == "DOWN":
			shrink()
	
	#When its not being scaled
	else:
		GlobalVar.state = "static"
		$GPUParticles3D.emitting = false
	
	
	if Input.is_key_pressed(KEY_X):
		shrink()
	
	if Input.is_key_pressed(KEY_C):
		grow()
		
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
		
	
		
	move_and_slide()

func grow():
	if GlobalVar.sizefactor <= 2:
		get_node("MeshInstance3D").scale += Vector3(rate,rate,0)
		get_node("CollisionShape3D").scale += Vector3(rate,rate,0)
		get_node("ColisionperuanaDer2").position.x += rate
		get_node("ColisionperuanaIzq").position.x -= rate
		get_node("ColisionArriba").position.y += rate
		
		get_node("ColisionperuanaDer2").scale.y += rate
		get_node("ColisionperuanaIzq").scale.y += rate
		get_node("ColisionArriba").scale.x += rate
		
		get_node("ColisionperuanaDer2").position.y = 0
		get_node("ColisionperuanaIzq").position.y = 0
		GlobalVar.sizeM = get_node("CollisionShape3D").scale
		GlobalVar.sizefactor = GlobalVar.sizeM.x
		GlobalVar.state = "growing"
		
		$GPUParticles3D.process_material.set_collision_mode(2)
		$GPUParticles3D.process_material.direction = Vector3(0,-1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.emitting = true
		#GlobalVar.ProgBar += rate

func shrink():
	if GlobalVar.sizefactor >= 0.1:
		get_node("MeshInstance3D").scale -= Vector3(rate,rate,0)
		get_node("CollisionShape3D").scale -= Vector3(rate,rate,0)
		get_node("ColisionperuanaDer2").position.x -= rate
		get_node("ColisionperuanaIzq").position.x += rate
		get_node("ColisionArriba").position.y -= rate
		
		get_node("ColisionperuanaDer2").scale.y -= rate
		get_node("ColisionperuanaIzq").scale.y -= rate
		get_node("ColisionArriba").scale.x -= rate
		
		get_node("ColisionperuanaDer2").position.y = 0
		get_node("ColisionperuanaIzq").position.y = 0
		GlobalVar.sizeM = get_node("CollisionShape3D").scale
		GlobalVar.sizefactor = GlobalVar.sizeM.x
		GlobalVar.state = "shrinking"
		$GPUParticles3D.process_material.direction = Vector3(0,1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.process_material.set_collision_mode(1)
		$GPUParticles3D.emitting = true

func toggle_pickup():
	if !find_child("pickinst"):
		try_pickup()
		print("trying pickup")
		
	else:
		print(pickup)
		print("releasing pickup")
		release_pickup()
		
func try_pickup():
	print(pos)
	pickinst.transform.origin = Vector3(0,2,0)
	pickinst.get_node("Pickup").freeze = true
	pickinst.get_node("Pickup/CollisionShape3D").disabled = true
	pickinst.get_node("Pickup/Area3D").monitoring = false
	pickup = false
	add_child(pickinst)

func release_pickup():
	print("release desde el player")
	
func _on_object_detect_body_entered(body):
	if body.name == "Pickup":
		print("Assin")
		pickup = true



func _on_object_detect_body_exited(body):
	if body.name == "Pickup":
		print("Assout")
		pickup = false
