extends RigidBody3D
#It doesn't have to be an Area node it can be a Rigidbody as well.
 
# Setting a breakable scene.
@export var resource : Resource
 
func break_object():
	# Instancing the breakable.
	var breakable = resource.instantiate()
	# Getting the parent of the Area node.
	var parent = self.get_parent()
	# Adding the breakable as a child of the parent.
	parent.add_child(breakable)
	#Setting the breakable's translation and rotation to the Area node.
	breakable.transform = self.transform
	breakable.rotation_degrees = self.rotation_degrees
	#print(breakable.get_children())
	
	# Deleting the Area node.
	self.queue_free()
	pass
	

func _on_body_entered(body):
	if body.name == "Pickup" or body.name == "Meatbox":
		break_object()
	
