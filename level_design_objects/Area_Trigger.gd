extends Area3D


signal entered(state, body)


func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("entered", false, body)
		queue_free()
	
