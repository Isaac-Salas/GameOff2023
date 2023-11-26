extends Node3D

func _ready():
	GlobalVar.MinCap = 1
	GlobalVar.MaxCap = 1
	GlobalVar.sizefactor = 1
	GlobalVar.sizestandard = 1
	$Player/RigidBody3D.mass = 1
