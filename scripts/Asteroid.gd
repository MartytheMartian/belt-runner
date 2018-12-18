extends Sprite

export(Vector2) var Velocity

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$VisibilityNotifier2D.connect("screen_exited", self, "_screen_exited")
	$AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	pass

func _process(delta):
	position.x += (Velocity.x * delta)
	position.y += (Velocity.y * delta)
	rotate(.01)
	pass

func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
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