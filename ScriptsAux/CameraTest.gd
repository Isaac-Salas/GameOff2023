extends Camera3D
var campos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = $"../Player".global_position.x
	position.y = $"../Player".global_position.y+8
	#print(rotation_degrees.y)
	
	if GlobalVar.direction == "right" and rotation_degrees.y > -5:
		rotation_degrees -= Vector3(0,0.1,0)

	
	if GlobalVar.direction == "left" and rotation_degrees.y < 5:
		rotation_degrees += Vector3(0,0.1,0)
	

		
