extends Area3D

var state = false
@export var lines: Array[String] =[
	"Hey, you seem pretty strong!",
	"Wanna spar?",
	"Wait...",
	"I shouldn't waste my energy before an important battle...",
	"Well, I'll see you at the buffet!",]

func _unhandled_input(event):
	if state and event.is_action_pressed("Talk"):
		DialogManager.start_dialog(global_position, lines)
		state = false

func _on_body_entered(body):
	if body.name == "Player":
		$Sprite3D.show()
		state = true


func _on_body_exited(body):
	if body.name == "Player":
		state = false 
		$Sprite3D.hide()
