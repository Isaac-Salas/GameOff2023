extends RigidBody3D
var bump = false
var thing
var playpos
# Called when the node enters the scene tree for the first time.
func _ready():
	set_linear_velocity(get_linear_velocity()+Vector3(0,0,0))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		#Peruvian collisions
	if bump == true:
		pass
#		if playpos.x > 0 and playpos.y > 0 and playpos.y < 1.2 :
#			set_linear_velocity(Vector3(-10,0,0))
#		if playpos.x < 0 and playpos.y > 0 and playpos.y < 1.2 :
#			set_linear_velocity(Vector3(10,0,0))


		

func _on_area_3d_body_entered(body):
	playpos = (body.global_position)-(get_node("Area3D").global_position)
	if body.name == "Player":
		print(playpos)
		bump = true
		thing = body
		return body


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		bump = false
		thing = body
		return body
