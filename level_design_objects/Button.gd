extends StaticBody3D
@onready var anim = $AnimationPlayer
func _ready():
	anim.play("Pressed Up")
	
func _on_button_hitbox_body_entered(body):
	if body.name != "ButCol":
		anim.play("Pressed Down")
		
func _on_button_hitbox_body_exited(body):
	if body.name != "ButCol":
		anim.play("Pressed Up")

