extends CharacterBody3D
var pickedobject = []
var pos = get_node(".").position
var pickupinst = preload("res://Pickups/PickObject.tscn")
var pickinst 
var mundotest
var startspeed = GlobalVar.SPEED
var startjump = GlobalVar.JUMP_VELOCITY
var lastSide = "right"

var stateC = snapped(GlobalVar.MaxCap/6, 0.01)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var itemsize
@onready var SMALL = AudioServer.get_bus_index("SMALL")
@onready var BIG = AudioServer.get_bus_index("BIG")

func _input(event):
	if Input.is_action_just_pressed("Interact"):
		if GlobalVar.objectPicked == true:
			release_pickup()
		else:
			try_pickup()
	if Input.is_action_just_pressed("Throw"):
		if GlobalVar.objectPicked == true:
			throw()


func _physics_process(delta):
	#print("size: ", GlobalVar.sizefactor, "comparative to:", stateC)
	sizecheck()
	#print("Jumpvel:",GlobalVar.JUMP_VELOCITY, "Vel:",GlobalVar.SPEED)
	position.z = 0
	#Updating the label
	#print(GlobalVar.sizefactor)




	#Peruvian Scaling
	if Input.is_action_pressed('Item'):
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
	
	
	if Input.is_action_pressed('Shrink'):
		#print(GlobalVar.CURRENT, GlobalVar.sizefactor)
		shrink()
	
	if Input.is_action_pressed('Grow'):
		#print(GlobalVar.CURRENT, GlobalVar.sizefactor)
		grow()
		
	# Add the gravity.
	if not is_on_floor():                     
		velocity.y -= (gravity*4) * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		var jumpanim = get_node("MeshInstance3D/Prot-Slime").find_child("AnimationPlayer")
		jumpanim.play("Armature|Jump Animation")
		velocity.y = GlobalVar.JUMP_VELOCITY
	
	# Speed and Jump velocity tweaks when shrinking or getting bigv
	if not GlobalVar.CURRENT == "NORMAL" and GlobalVar.sizefactor < GlobalVar.sizestandard:
		GlobalVar.SPEED = snapped(100 / (2.5 + GlobalVar.sizefactor), 1)
		GlobalVar.JUMP_VELOCITY =snapped( 200 / (4.5 + GlobalVar.sizefactor),1 )
		#pr int("Velocidad: ", GlobalVar.SPEED, "Vel. Salto: ",GlobalVar.JUMP_VELOCITY )
	else:
		GlobalVar.SPEED = startspeed
		GlobalVar.JUMP_VELOCITY = startjump



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with ass gameplay actions.
	var input_dir = Input.get_vector("Walk_Left", "Walk_Right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y,0)).normalized()
	
	
	if direction:
		if direction.x > 0: 
			lastSide = "right" 
		else: 
			lastSide = "left"
	#-------------------------------------------------------------------------------------------------------
	#Perfect example of peruvian solutions c:
	if direction:
		velocity.x = direction.x * (GlobalVar.SPEED)
		velocity.z = 0
	else:
		velocity.x = move_toward(velocity.x, 0, (GlobalVar.SPEED))
		velocity.z = 0
		
	if pickedobject.size() > 0:
		pickedobject[0].get_child(1).show()
	for i in range(1, pickedobject.size()):
		pickedobject[i].get_child(1).hide()
	
	move_and_slide()


func sizecheck():
	if GlobalVar.sizefactor < (stateC*3):
		GlobalVar.CURRENT = "SMALL"
	elif GlobalVar.sizefactor > (stateC*5):
		GlobalVar.CURRENT = "BIG"
	else:
		GlobalVar.CURRENT = "NORMAL"
	

func throw():
	mundotest = get_parent_node_3d()
	$MeshInstance3D.remove_child(pickinst)
	pickinst.transform.origin = Vector3(0,2,0)
	pickinst.resize()
	if lastSide == "right":		
		pickinst.linear_velocity = Vector3(20,0,0)
		pickinst.transform.origin = global_position+Vector3((1.65*GlobalVar.sizefactor),0,0)
	else:
		pickinst.linear_velocity = Vector3(-20,0,0)
		pickinst.transform.origin = global_position+Vector3(-(1.65*GlobalVar.sizefactor),0,0)
	pickinst.freeze = false
	pickinst.get_node("CollisionShape3D").disabled = false
	pickinst.get_node("Area3D").monitoring = true
	GlobalVar.objectPicked = false
	mundotest.add_child(pickinst)
	
	

func grow():
	if GlobalVar.sizefactor < GlobalVar.MaxCap:
		dyn_music()
		scale += Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,GlobalVar.Scalerate) 
		GlobalVar.sizeM = scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, 0.1)
		GlobalVar.state = "growing"
		
		$GPUParticles3D.process_material.set_collision_mode(2)
		$GPUParticles3D.process_material.direction = Vector3(0,-1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.emitting = true
		#GlobalVar.ProgBar += GlobalVar.Scalerate

func shrink():
	if GlobalVar.sizefactor > GlobalVar.MinCap and GlobalVar.sizefactor > 0 :
		
		dyn_music()
		scale -= Vector3(GlobalVar.Scalerate,GlobalVar.Scalerate,GlobalVar.Scalerate) 
		GlobalVar.sizeM = scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, 0.1) 
		GlobalVar.state = "shrinking"
		$GPUParticles3D.process_material.direction = Vector3(0,1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.process_material.set_collision_mode(1)
		$GPUParticles3D.emitting = true
		

func dyn_music():
	
	if GlobalVar.CURRENT == "NORMAL":
		AudioServer.set_bus_volume_db(SMALL,0)
		AudioServer.set_bus_volume_db(SMALL,0)
	
	if GlobalVar.CURRENT == "SMALL":
		GlobalVar.VolBig -= 0.05
		AudioServer.set_bus_volume_db(BIG,GlobalVar.VolBig)
		
		if AudioServer.get_bus_volume_db(SMALL) < 0:
			GlobalVar.VolSmall += 0.05
			AudioServer.set_bus_volume_db(SMALL, GlobalVar.VolSmall)
		
	if GlobalVar.CURRENT == "BIG":
		GlobalVar.VolSmall -= 0.05
		AudioServer.set_bus_volume_db(SMALL,GlobalVar.VolSmall)
		
		if AudioServer.get_bus_volume_db(BIG) < 0:
			GlobalVar.VolBig += 0.05
			AudioServer.set_bus_volume_db(BIG, GlobalVar.VolBig)
					
	



func try_pickup():
	if pickedobject.size() > 0:
		pickinst =  pickupinst.instantiate()
		print("espacio del jugador" + str(pos))
		print("Espacio del objeto" + str(pickinst.transform.origin))
		print("pickup desde el player")
		pickinst.transform.origin = Vector3(0,(1.5*GlobalVar.sizefactor),0)
		pickinst.freeze = true
		pickinst.get_node("CollisionShape3D").disabled = true
		pickinst.get_node("Area3D").monitoring = false
		GlobalVar.objectPicked = true
		$MeshInstance3D.add_child(pickinst)
		get_parent_node_3d().remove_child(pickedobject[0])
		if mundotest != null:
			mundotest.remove_child(pickinst)
		
		var direction_to_object = (pickinst.global_position - global_position).normalized()
		var distance_to_object = (pickinst.global_position - global_position).length()
		var desired_distance = 1.6
		var adjusted_distance = desired_distance * GlobalVar.sizefactor
		pickinst.global_position = global_position + direction_to_object * adjusted_distance

func release_pickup():
	print("release desde el player")
	if GlobalVar.objectPicked:
		mundotest = get_parent_node_3d()
		#Itemsize*sizefactor
		$MeshInstance3D.remove_child(pickinst)
		pickupinst = preload("res://Pickups/PickObject.tscn")
		pickinst =  pickupinst.instantiate()
		#Itemsize*sizefactor
		pickinst.transform.origin = Vector3(0,2,0)
		pickinst.freeze = false
		pickinst.get_node("CollisionShape3D").disabled = false
		pickinst.get_node("Area3D").monitoring = true
		pickinst.resize()
		GlobalVar.objectPicked = false
		if lastSide == "right":
			pickinst.transform.origin = global_position+Vector3((1.65*GlobalVar.sizefactor),0,0)
		else:
			pickinst.transform.origin = global_position+Vector3(-(1.65*GlobalVar.sizefactor),0,0)

		mundotest.add_child(pickinst)


var inside_count = 0
func _on_object_detect_body_entered(body):
	pickedobject.push_front(body)

func _on_object_detect_body_exited(body):
	body.get_child(1).hide()
	pickedobject.erase(body)


func _on_rigid_body_3d_body_entered(body):
	print(body.name)
	
