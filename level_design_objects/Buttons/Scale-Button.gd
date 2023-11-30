extends StaticBody3D
@onready var anim = $AnimationPlayer
signal pressed(state)
var state = false
@export var activation_weight = 1
@onready var display = $Sprite
var weight_inside = 0
var bodys_inside = []
var delta = 0
var sign = false

func _ready():
	display.play("0")
	anim.play("Pressed Up")

func _process(_delta):
	if bodys_inside.size() > 0 and update() and !sign:
		sign = true
		emit_signal("pressed", state)
	else:
		sign = false
func _on_button_hitbox_body_entered(body):
	if body.name != "ButtonHitbox" and body.name != 'BaseHitbox':
		bodys_inside.push_back(body)
		if  not state:
			state = true
			anim.play("Pressed Down")

func _on_button_hitbox_body_exited(body):
	if body.name != "ButtonHitbox" and body.name != 'BaseHitbox':
		bodys_inside.erase(body)
		if bodys_inside.size() == 0:
			display.play('0')
			state = false
			anim.play("Pressed Up")
		
func update():
	weight_inside = 0
	for body in bodys_inside:
		if body.name == "Player":
			weight_inside += body.get_node('PlayerRigid').mass
		else:
			weight_inside += body.mass
	delta = 1 - (activation_weight - weight_inside) / activation_weight
	if delta <= 0:
		display.play("0")
		
	elif delta <= 0.1428571428571429:
		display.play("1")
		
	elif delta <= 0.2857142857142858:
		display.play("2")
		
	elif delta <= 0.4285714285714286:
		display.play("3")
		
	elif delta <= 0.5714285714285714:
		display.play("4")

	elif delta <= 0.7142857142857143:
		display.play("5")

	elif delta <= 0.8571428571428571:
		display.play("6")

	elif delta <= 1:
		display.play("7")
		return true
		
	else: #Overweighted
		display.play("8")
	return false
