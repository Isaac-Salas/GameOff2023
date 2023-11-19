extends Node3D
var pickup = false

var player = null
var root
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_key_pressed(KEY_V) and pickup == true:
		print("pickup desde el objeto")
		
	if Input.is_key_pressed(KEY_V) and pickup == false:
		#queue_free()
		#transform.origin = get_node("Player").transform.origin + Vector3(0,-2,-2)
		print("release desde el objeto")

func resize():
#	$.scale = ($MeshInstance3D.scale*Vector3(GlobalVar.sizefactor,GlobalVar.sizefactor,GlobalVar.sizefactor))
	$Outline.scale = ($MeshInstance3D.scale*Vector3(GlobalVar.sizefactor,GlobalVar.sizefactor,GlobalVar.sizefactor))
	$MeshInstance3D.scale = ($MeshInstance3D.scale*Vector3(GlobalVar.sizefactor,GlobalVar.sizefactor,GlobalVar.sizefactor))
	$CollisionShape3D.scale = $CollisionShape3D.scale*Vector3(GlobalVar.sizefactor,GlobalVar.sizefactor,GlobalVar.sizefactor)
	$Area3D.scale = $Area3D.scale*Vector3(GlobalVar.sizefactor,GlobalVar.sizefactor,GlobalVar.sizefactor)


#func colorchange(value):
#	if value == 1:
#		var new_color = $MeshInstance3D.mesh.material
#		#new_color.albedo_color = Color(0, 0, 255)
		#$Outline.show()
#	if value == 2:
#		var new_color = $MeshInstance3D.mesh.material
#		#new_color.albedo_color = Color(255, 0, 0)
#		$Outline.hide()
func toggle_outline():
	if visible:
		$Outline.hide()
	else:
		$Outline.show()
		
func _on_area_3d_area_entered(area):
	toggle_outline()
#	if area.name == 'ObjectDetect':
#		$Outline.show()
	pass	


func _on_area_3d_area_exited(area):
	toggle_outline()
#	if area.name == 'ObjectDetect':
#		$Outline.hide()
	pass

