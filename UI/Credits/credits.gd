extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label/AnimationPlayer.play("Credits")


func _on_texture_button_2_pressed():
	get_tree().change_scene_to_file("res://Menu/Title-Screen.tscn")
