extends Sprite

var velocity = Vector2(150, 0)

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$AnimationPlayer.play("Idle")
	$Turret.show()
	
	# World events
	BeltRunner.connect("faster_recharge", self, "_fasterRecharge")
	BeltRunner.connect("slower_recharge", self, "_slowerRecharge")
	pass
	
func _process(delta):
	# Move the player
	position.x += (velocity.x * delta)
	pass
	
func _collide(object):
	if (object.is_in_group("eol")):
		return
		
	$Area2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Explode")
	$AudioStreamPlayer2D.play()
	$Turret.hide()
	velocity.x = 0
	pass

func _slowerRecharge():
	$MissileGenerator.slowerRecharge()
	pass

func _fasterRecharge():
	$MissileGenerator.fasterRecharge()
	pass