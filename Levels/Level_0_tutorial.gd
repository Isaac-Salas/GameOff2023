extends Node3D
@export var min_cap = 1.0
@export var max_cap = 1.0
@export var size_factor = 1.0
@export var size_standard = 1.0

func _ready():
	GlobalVar.MinCap = min_cap
	GlobalVar.MaxCap = max_cap
	GlobalVar.sizefactor = size_factor
	GlobalVar.sizestandard = size_standard
	GlobalVar.SPEED = 10.0
	GlobalVar.JUMP_VELOCITY = 20.0
	$Player/PlayerRigid.mass = size_standard

func _process(_delta):
	GlobalVar.MinCap = $Player.scale.x
	GlobalVar.MaxCap = $Player.scale.x
