extends Node2D

var _rateChanged = false
var _reset = 0
var _rechargeTime = .5
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
	_lastShot = _rechargeTime

	# Get mouse position
	var mousePosition = get_local_mouse_position()
	
	# Build the missile
	var missile = preload("res://scenes/Missile.tscn").instance()
	
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
		
	# Do nothing if the rate is normal
	if !_rateChanged:
		return
	 
	# Determine if rate should be reset
	if _reset <= 0:
		_rateChanged = false
		_rechargeTime = .5
		return
		
	# Countdown on reset
	_reset -= delta
	pass

# Handles the 'slow recharge' event
func slowerRecharge():
	_rechargeTime = 1
	_reset = 5
	_rateChanged = true
	pass
	
# Handles the 'faster recharge' event
func fasterRecharge():
	_rechargeTime = .1
	_reset = 5
	_rateChanged = true
	pass