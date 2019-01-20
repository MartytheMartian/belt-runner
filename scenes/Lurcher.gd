extends Sprite

var _delay = 2.3
var _velocity
var _done = false

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	
	# Calculate velocity
	_velocity = BeltRunner.calculate_velocity(self.position, Vector2(0, 0), 1500)
	
	# Start attacking
	$Attack.play()
	pass

func _process(delta):
	if _done:
		return
		
	# Wait
	if _delay > 0:
		_delay -= delta
		return
		
	# Move
	position.x += (_velocity.x * delta)
	position.y += (_velocity.y * delta)
	
	# Check if done
	if (abs(position.x) < 10):
		position.x = 0
		position.y = 0
		_done = true
		$Laugh.play()
	pass

func _collide(body):
	if _delay <= 0:
		queue_free()
	pass