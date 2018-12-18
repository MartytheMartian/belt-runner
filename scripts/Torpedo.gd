extends Sprite

export(Vector2) var Velocity

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$VisibilityNotifier2D.connect("screen_exited", self, "_exited_screen")
	pass

func _process(delta):
	position.x += (Velocity.x * delta)
	position.y += (Velocity.y * delta)
	pass

func _collide(object):
	queue_free()
	pass
	
func _exited_screen():
	queue_free()
	pass