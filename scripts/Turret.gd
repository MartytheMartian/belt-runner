extends Sprite

# Called when an input happens
func _input(event):
	# Ignore non-mouse clicks
	if !(event is InputEventMouseButton):
		return
	
	# Get mouse position
	var mousePosition = get_global_mouse_position()
	
	# Calculate the rotation
	var mRotation = get_angle_to(mousePosition)
	
	rotate(mRotation)
	pass