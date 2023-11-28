extends CharacterBody3D
var player
var SPEED = GlobalVar.SPEED

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite3D.play("Run")

func loadPlayer():
	player = get_node(player_path)

func update_target(target_location):
	nav_agent.target_position = target_location


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	update_target(player.global_transform.origin)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = new_velocity
	move_and_slide()


func _on_navigation_agent_3d_target_reached():
	$AnimatedSprite3D.play("Catch")
	$RigidBody3D.linear_velocity.x = 50
	
	print("Reached")
