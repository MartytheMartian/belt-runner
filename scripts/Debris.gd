extends Sprite

export(Vector2) var Velocity

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	$VisibilityNotifier2D.connect("screen_exited", self, "_exitedScreen")
	pass

func _process(delta):
	rotate(delta * -.66)
	position.x += (Velocity.x * delta)
	position.y += (Velocity.y * delta)
	pass
	

func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
	pass
	
func _animation_finished(animation):
	if animation == "Explode":
		queue_free()
	pass
	
func _exitedScreen():
	queue_free()
	pass