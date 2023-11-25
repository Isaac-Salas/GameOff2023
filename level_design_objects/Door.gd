extends StaticBody3D
var isOpen = false
var inAnimation = false
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("Close Door")
	
func toggle_door(state, body):
	isOpen = state
	if isOpen:
		anim.play("Open Door")
	else:
		anim.play("Close Door")
	
