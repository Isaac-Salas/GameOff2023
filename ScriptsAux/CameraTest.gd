extends Camera3D
var campos
@onready var follow = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if size > 40:
		size -= 0.5
	
	match follow:
		true:
			position.x = $"../Player".global_position.x
			position.y = $"../Player".global_position.y+8
			position.z = $"../Player".global_position.z+20
		false:
			pass
	
	if GlobalVar.state == "growing":
		position.z += 0.1
	if GlobalVar.state == "shrinking":
		position.z -= 0.1
	if GlobalVar.sizefactor < 0.1:
		size -= 0.2
		rotation_degrees.z -= 0.5
	
	#print(rotation_degrees.y)
	
	if GlobalVar.direction == "right" and rotation_degrees.y > -5:
		rotation_degrees -= Vector3(0,0.1,0)

	
	if GlobalVar.direction == "left" and rotation_degrees.y < 5:
		rotation_degrees += Vector3(0,0.1,0)
	

		
