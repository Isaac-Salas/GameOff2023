extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.z > 2.15:
		position.z -= 0.01
		if position.z < 4:
			position.x -= 0.005
