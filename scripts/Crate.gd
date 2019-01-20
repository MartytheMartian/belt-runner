extends Sprite

export(Vector2) var Velocity
export(String, "Nothing", "Kill Everything", "Faster Recharge Rate", "Slower Recharge Rate", "Faster Enemies", "Lurcher") var Powerup

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	$VisibilityNotifier2D.connect("screen_exited", self, "_exited_screen")
	pass

func _process(delta):
	rotate(delta * -.66)
	self.position.x += Velocity.x * delta
	self.position.y += Velocity.y * delta
	pass
	

func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
	
	# Determine the right event to emit
	if Powerup == "Kill Everything":
		BeltRunner.emit_signal("kill_everything")
	elif Powerup == "Faster Recharge Rate":
		BeltRunner.emit_signal("faster_recharge")
	elif Powerup == "Slower Recharge Rate":
		BeltRunner.emit_signal("slower_recharge")
	elif Powerup == "Faster Enemies":
		BeltRunner.emit_signal("faster_enemies")
	elif Powerup == "Lurcher":
		BeltRunner.emit_signal("lurcher", self.position)
	else:
		print("NO POWERUP PROVIDED")
	pass
	
func _animation_finished(animation):
	if animation == "Explode":
		queue_free()
	pass
	
func _exited_screen():
	queue_free()
	pass