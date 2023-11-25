extends Node3D
var state = true

func toggle_light():
	if state:
		$OmniLight3D.hide()
		state = false
	else:
		$OmniLight3D.show()
		state = true
	$LampBody.mesh.material.emission_enabled = state
