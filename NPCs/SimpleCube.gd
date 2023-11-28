extends RigidBody3D

var state = false
const lines: Array[String] =[
	"Hey, you seem pretty strong!",
	"Wanna spar?",
	"Wait...",
	"I shouldn't waste my energy before an important battle...",
	"Well, I'll see you at the buffet!",]

func _unhandled_input(event):
	if state and event.is_action_pressed("Interact"):
		DialogManager.start_dialog(global_position, lines)
		state = false
	
func _on_area_3d_body_entered(body):
	if body.name == "Player":
		state = true

func _on_area_3d_body_exited(body):
	state = false # Replace with function body.

#var bump = false
#var thing
#var playpos
# Called when the node enters the scene tree for the first time.
#func _ready():
#	set_linear_velocity(get_linear_velocity()+Vector3(0,0,0))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
		#Peruvian collisions
#	if bump == true:
#		pass
#		if playpos.x > 0 and playpos.y > 0 and playpos.y < 1.2 :
#			set_linear_velocity(Vector3(-10,0,0))
#		if playpos.x < 0 and playpos.y > 0 and playpos.y < 1.2 :
#			set_linear_velocity(Vector3(10,0,0))
		#bump = true
		#thing = body
		#return body


#func _on_area_3d_body_exited(body):
#	if body.name == "Player":
#		bump = false
#		thing = body
#		return body

