extends CharacterBody3D
var pickedobject = []
var pos = get_node(".").position
var pickupinst
var pickinst 
var mundotest
@export var startspeed = GlobalVar.SPEED
@export var startjump = GlobalVar.JUMP_VELOCITY
var lastSide = "right"
@onready var Animate = get_node("MeshInstance3D/Prot-Slime").find_child("AnimationPlayer")

@onready var corner_direction = $Check_Corner
@onready var wall_cast = $Check_Corner/RayCast3D_wall
@onready var floor_cast = $Check_Corner/RayCast3D_floor

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
		if velocity.y <= 0:
			floor_cast.enabled = true
			wall_cast.enabled = true
		if near_ledge() and touching_wall():
			velocity.y = 0
			velocity.x = 0
		elif velocity.y < 100:
			velocity.y -= (gravity*4) * delta
	else:
		floor_cast.enabled = false
		wall_cast.enabled = false

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or (near_ledge() and touching_wall())):
		Animate.stop()
		Animate.play("Armature|Jump Animation")
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
		Animate.play("Walk?")
		velocity.x = direction.x * (GlobalVar.SPEED)
		velocity.z = 0
		if direction.x > 0: 
			lastSide = "right" 
			GlobalVar.direction = "right"
			corner_direction.scale.x = 1
		else: 
			lastSide = "left"
			GlobalVar.direction = "left"
			corner_direction.scale.x = -1
	#-------------------------------------------------------------------------------------------------------

	else:
		Animate.play("Idle")
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


func grow(amount = GlobalVar.Scalerate):
	if GlobalVar.sizefactor < GlobalVar.MaxCap and GlobalVar.sizefactor > 0:
		dyn_music()
		
		scale += Vector3(amount, amount, amount)
		GlobalVar.sizeM = scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, amount)
		
		
		GlobalVar.state = "growing"
		$PlayerRigid.mass = scale.x
		
		$GPUParticles3D.process_material.set_collision_mode(2)
		$GPUParticles3D.process_material.direction = Vector3(0,-1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.one_shot = false
		$GPUParticles3D.emitting = true

func shrink(amount = GlobalVar.Scalerate):
	if GlobalVar.sizefactor - amount/2 > GlobalVar.MinCap and GlobalVar.sizefactor > 0:
		dyn_music()
		
		scale -= Vector3(amount, amount, amount) 
		GlobalVar.sizeM = scale
		GlobalVar.sizefactor = snapped(GlobalVar.sizeM.x, amount)
		
		
		GlobalVar.state = "shrinking"
		$PlayerRigid.mass = scale.x
		$GPUParticles3D.process_material.direction = Vector3(0,1,0)
		$GPUParticles3D.process_material.set("lifetime", 4)
		$GPUParticles3D.process_material.set_collision_mode(1)
		$GPUParticles3D.one_shot = false
		$GPUParticles3D.emitting = true

func near_ledge():
	return floor_cast.is_colliding()

func touching_wall():
	return wall_cast.is_colliding()

func dyn_music():
	pass
func try_pickup():
	if pickedobject.size() > 0:
		pickupinst = load(String(pickedobject[0].scene_file_path))
		pickinst =  pickupinst.instantiate()
#		print("espacio del jugador" + str(pos))
#		print("Espacio del objeto" + str(pickinst.transform.origin))
#		print("pickup desde el player")
		pickinst.transform.origin = Vector3(0,(1.5*GlobalVar.sizefactor),0)
		pickinst.freeze = true
		pickinst.get_node("CollisionShape3D").disabled = true
		pickinst.get_node("Area3D").monitoring = false
		GlobalVar.objectPicked = true
		$MeshInstance3D.add_child(pickinst)
		
		if pickinst.find_child("Meatbox"):
			pickinst.toggle()
		
		pickedobject[0].get_parent_node_3d().remove_child(pickedobject[0])
		if mundotest != null:
			mundotest.remove_child(pickinst)

		
		var direction_to_object = (pickinst.global_position - global_position).normalized()
		var distance_to_object = (pickinst.global_position - global_position).length()
		var desired_distance = 1.6
		var adjusted_distance = desired_distance * GlobalVar.sizefactor
		pickinst.global_position = global_position + direction_to_object * adjusted_distance

func release_pickup():
#	print("release desde el player")
	if GlobalVar.objectPicked and !is_on_wall():
		mundotest = get_parent_node_3d()
		#Itemsize*sizefactor
		$MeshInstance3D.remove_child(pickinst)
		#pickupinst = load(GlobalVar.pickedpath)
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

func throw():
	if !is_on_wall():
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

func _on_ray_collided(target_scale):
	scale = Vector3(target_scale, target_scale, target_scale) 
	GlobalVar.sizeM = scale
	GlobalVar.sizefactor = target_scale
	$PlayerRigid.mass = scale.x
	$GPUParticles3D.process_material.set_collision_mode(1)
	$GPUParticles3D.process_material.direction = Vector3(0,0,0)
	$GPUParticles3D.one_shot = true
	$GPUParticles3D.emitting = true

func goo():
	$GPUParticles3D.process_material.set_collision_mode(1)
	$GPUParticles3D.process_material.direction = Vector3(0,0,0)
	$GPUParticles3D.one_shot = true
	$GPUParticles3D.emitting = true

func hit(target_scale):
	if GlobalVar.sizefactor > 0:
		scale = Vector3(target_scale, target_scale, target_scale) 
		GlobalVar.sizeM = scale
		GlobalVar.sizefactor = target_scale
		GlobalVar.sizestandard = target_scale
		GlobalVar.MinCap = target_scale
		GlobalVar.MaxCap = target_scale
		$PlayerRigid.mass = scale.x



func _on_object_detect_body_entered(body):
	if body.find_child("Pickable") or body.find_child("Meatbox"):
		pickedobject.push_front(body)

func _on_object_detect_body_exited(body):
	if body.find_child("Pickable") or body.find_child("Meatbox"):
		body.get_child(1).hide()
		pickedobject.erase(body)

func _on_rigid_body_3d_body_entered(body):
	pass
#	print(body.name)
