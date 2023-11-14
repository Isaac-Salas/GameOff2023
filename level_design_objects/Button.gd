extends StaticBody3D
@onready var anim = $AnimationPlayer
signal pressed(state, body)
func _ready():
	anim.play("Pressed Up")
	
func _on_button_hitbox_body_entered(body):
	if body.name != "ButCol":
		emit_signal("pressed", true, body)
		anim.play("Pressed Down")
		
func _on_button_hitbox_body_exited(body):
	if body.name != "ButCol":
		emit_signal("pressed", false, body)
		anim.play("Pressed Up")

