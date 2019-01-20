extends Sprite

export(Vector2) var Velocity

var _faster = 0

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	$VisibilityNotifier2D.connect("screen_exited", self, "_exited_screen")
	
	# Hook events
	BeltRunner.connect("kill_everything", self, "_killEverything")
	BeltRunner.connect("faster_enemies", self, "_fasterEnemies")
	pass

func _process(delta):
	# Move
	move(delta)
	
	# Do nothing if faster is good
	if _faster == 0:
		return
		
	# Adjust faster time
	_faster -= delta
	
	# Reset velocity if necessary
	if _faster <= 0:
		_faster = 0
		Velocity /= 1.5
	pass

# Moves the entity
func move(delta):
	position.x += (Velocity.x * delta)
	position.y += (Velocity.y * delta)
	pass

func _collide(object):
	_kill()
	pass

func _screen_exited():
	queue_free()
	pass
	
func _animation_finished(animation):
	if animation == "Explode":
		queue_free()
	pass
	
func _exited_screen():
	queue_free()
	pass
	
func _kill():
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
	pass
	
# Called when the kill everything event occurs
func _killEverything():
	_kill()
	pass
	
# Called when the faster enemies event occurs
func _fasterEnemies():
	# Do nothing if already faster
	if _faster > 0:
		return
		
	# Set to 'faster' mode
	_faster = 2
	
	# Increase velocity
	Velocity *= 1.5
	pass