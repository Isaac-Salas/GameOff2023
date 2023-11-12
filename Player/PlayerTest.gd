extends CharacterBody3D

var pos = get_node(".").position
var pickupinst = preload("res://Pickups/PickObject.tscn")
var pickinst = pickupinst.instantiate()
var globalinst = pickupinst.instantiate()
var objectPicked = null
var pickup
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if Input.is_key_pressed(KEY_V):
		if objectPicked == true:
			release_pickup()
		else:
			try_pickup()


func _physics_process(delta):
	#print("Jumpvel:",GlobalVar.JUMP_VELOCITY, "Vel:",GlobalVar.SPEED)
	position.z = 0
	
	#Updating the label
	#print(GlobalVar.sizefactor)

	if GlobalVar.sizefactor<=(GlobalVar.MinCap+GlobalVar.MaxCap)/3: 
		#print ((GlobalVar.MinCap+GlobalVar.MaxCap)/3)
		GlobalVar.CURRENT = "SMALL"
	elif GlobalVar.sizefactor<=(GlobalVar.MaxCap/2)*1.5:
		GlobalVar.CURRENT = "NORMAL"
	else:
		GlobalVar.CURRENT = "BIG"



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
		#print(GlobalVar.CURRENT, GlobalVar.sizefactor)
		shrink()
	
	if Input.is_key_pressed(KEY_C):
		#print(GlobalVar.CURRENT, GlobalVar.sizefactor)
		grow()
		
	# Add the gravity.
	if not is_on_floor():                     
		velocity.y -= (gravity*4) * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var jumpanim = get_node("MeshInstance3D/Prot-Slime 3d").find_child("AnimationPlayer")
		jumpanim.play("Jump Animation")
		velocity.y = GlobalVar.JUMP_VELOCITY
	
	# Speed and Jump velocity tweaks when shrinking or getting bigv
	if not GlobalVar.CURRENT == "NORMAL" and GlobalVar.sizefactor < 1:
		GlobalVar.SPEED = snapped(10 / (0.3 + GlobalVar.sizefactor), 1)
		GlobalVar.JUMP_VELOCITY =snapped( 20 / (0.3 + GlobalVar.sizefactor),1 )
	else:
		GlobalVar.SPEED = 10
		GlobalVar.JUMP_VELOCITY = 20



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
	if GlobalVar.sizefactor < GlobalVar.MaxCap:
		get_node("MeshInstance3D").scale += Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,0)
		get_node("CollisionShape3D").scale += Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,0)
		get_node("ColisionperuanaDer2").position.x += GlobalVar.Scalerate
		get_node("ColisionperuanaIzq").position.x -= GlobalVar.Scalerate
		get_node("ColisionArriba").position.y += GlobalVar.Scalerate
		
		get_node("ColisionperuanaDer2").scale.y += GlobalVar.Scalerate
		get_node("ColisionperuanaIzq").scale.y += GlobalVar.Scalerate
		get_node("ColisionArriba").scale.x += GlobalVar.Scalerate
		
		get_node("ColisionperuanaDer2").position.y = 0
		get_node("ColisionperuanaIzq").position.y = 0
		GlobalVar.sizeM = get_node("CollisionShape3D").scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, 0.1)
		GlobalVar.state = "growing"
		
		$GPUParticles3D.process_material.set_collision_mode(2)
		$GPUParticles3D.process_material.direction = Vector3(0,-1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.emitting = true
		#GlobalVar.ProgBar += GlobalVar.Scalerate

func shrink():
	if GlobalVar.sizefactor > GlobalVar.MinCap:
		get_node("MeshInstance3D").scale -= Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,0)
		get_node("CollisionShape3D").scale -= Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,0)
		get_node("ColisionperuanaDer2").position.x -= GlobalVar.Scalerate
		get_node("ColisionperuanaIzq").position.x += GlobalVar.Scalerate
		get_node("ColisionArriba").position.y -= GlobalVar.Scalerate
		
		get_node("ColisionperuanaDer2").scale.y -= GlobalVar.Scalerate
		get_node("ColisionperuanaIzq").scale.y -= GlobalVar.Scalerate
		get_node("ColisionArriba").scale.x -= GlobalVar.Scalerate
		
		get_node("ColisionperuanaDer2").position.y = 0
		get_node("ColisionperuanaIzq").position.y = 0
		GlobalVar.sizeM = get_node("CollisionShape3D").scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, 0.1) 
		GlobalVar.state = "shrinking"
		$GPUParticles3D.process_material.direction = Vector3(0,1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.process_material.set_collision_mode(1)
		$GPUParticles3D.emitting = true


		
func try_pickup():
	if pickup == true:
		print("espacio del jugador" + str(pos))
		print("Espacio del objeto" + str(pickinst.transform.origin))
		print("pickup desde el player")
		pickinst.transform.origin = Vector3(0,2,0)
		pickinst.get_node("Pickup").freeze = true
		pickinst.get_node("Pickup/CollisionShape3D").disabled = true
		pickinst.get_node("Pickup/Area3D").monitoring = false
		pickup = false
		add_child(pickinst)
		objectPicked = true

func release_pickup():
	print("release desde el player")
	if objectPicked:
		globalinst = pickupinst.instantiate()
		remove_child(pickinst)
		globalinst.transform.origin = Vector3(0,2,0)
		globalinst.get_node("Pickup").freeze = false
		globalinst.get_node("Pickup/CollisionShape3D").disabled = false
		globalinst.get_node("Pickup/Area3D").monitoring = true
		pickup = false
		globalinst.transform.origin = global_position+Vector3(2,0,0)
		var mundotest = get_parent_node_3d()
		mundotest.add_child(globalinst)
		objectPicked = false



func _on_object_detect_body_entered(body):
	if body.name == "Pickup":
		print("Assin")
		pickup = true

func _on_object_detect_body_exited(body):
	if body.name == "Pickup":
		print("Assout")
		pickup = false
