extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	mesh.surface_add_vertex(to_local($"../RayCast3D".global_transform.origin))
	mesh.surface_add_vertex(to_local($"../RayCast3D".get_collision_point()))
	mesh.surface_end()
