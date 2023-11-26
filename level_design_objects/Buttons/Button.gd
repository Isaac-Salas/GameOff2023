extends StaticBody3D
@onready var anim = $AnimationPlayer
signal pressed(state, body)
var state = false
var n_inside = 0

func _ready():
	anim.play("Pressed Up")
	
func _on_button_hitbox_body_entered(body):
	if body.name != "ButtonHitbox" and body.name != 'BaseHitbox':
		n_inside += 1
		
		if  not state:
			state = true
			anim.play("Pressed Down")
			emit_signal("pressed", state, body)
			
func _on_button_hitbox_body_exited(body):
	if body.name != "ButtonHitbox" and body.name != 'BaseHitbox':
		n_inside -= 1
		if state and n_inside == 0:	
			state = false
			emit_signal("pressed", state, body)
			anim.play("Pressed Up")

