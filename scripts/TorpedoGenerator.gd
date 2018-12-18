#extends Node2D
#
#export (float) var frequency
#
#var _lastShot = 0
#
#func _ready():
#	_lastShot = frequency
#	pass
#
#func _process(delta):
#	# Keep reducing the 'last shot' check if necessary
#	if _lastShot > 0:
#		_lastShot -= delta
#		return
#
#	# Reset the last shot counter
#	_lastShot = frequency
#
#	# Fire
#
#	pass

extends Node2D

var _lastShot = 0

# Called when an input happens
func _input(event):
	# Ignore non-mouse clicks
	if !(event is InputEventMouseButton):
		return
		
	# Return if not ready
	if _lastShot > 0:
		return
		
	# Get the missile queue. Return if too many.
	if get_child_count() > 9:
		return

	# Reset counter
	_lastShot = .5

	# Get mouse position
	var mousePosition = get_local_mouse_position()
	
	# Build the missile
	var missile = preload("res://scenes/Torpedo.tscn").instance()
	
	# Calculate the rotation
	var mRotation = missile.get_angle_to(mousePosition)
	
	# Spawn missile
	missile.position.x = 0
	missile.position.y = 0
	missile.rotate(mRotation)
	missile.Velocity = BeltRunner.calculate_velocity(missile.position, mousePosition, 1100)
	add_child(missile)

	# Play the missile sound
	$AudioStreamPlayer2D.play()
	pass
	
# Called per frame
func _process(delta):
	# Remove counter on last frame
	if _lastShot > 0:
		_lastShot -= delta
	pass