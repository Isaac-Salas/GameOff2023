extends Sprite3D

var coins = 5
var Player_Name = "Robot"
var hearts = 3.5
const SPEED = 2
var x = coins+SPEED



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotate_y(deg_to_rad(15))



