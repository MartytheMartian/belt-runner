extends Sprite

var velocity = Vector2(150, 0)

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$AnimationPlayer.play("Idle")
	$Turret.show()
	pass
	
func _process(delta):
	# Move the player
	position.x += (velocity.x * delta)
	pass
	
func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
	$Turret.hide()
	velocity.x = 0
	pass
