extends Node3D
var state = false

func toggle_light():
	if state:
		$OmniLight3D.hide()
		state = false
	else:
		$OmniLight3D.show()
		state = true
	$LampBody.mesh.material.emission_enabled = state


func _on_button_pressed(state, body):
	toggle_light()
