extends Node

# Powerup Signals
signal kill_everything
signal faster_recharge
signal slower_recharge
signal faster_enemies
signal lurcher(position)

# Game signals
signal eol
signal died

# Calculates velocity to get from one point to another
# Given a static speed. Vector2, Vector2, Float
func calculate_velocity(start, end, speed):
	# Calculate differences
	var difX = end.x - start.x
	var difY = end.y - start.y
	
	# Calculate distance
	var distance = sqrt((difX * difX) + (difY * difY))
	var sdist = speed / distance

	return Vector2(sdist * difX, sdist * difY)
	pass
