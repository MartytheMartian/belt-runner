extends Node2D

var _sceneChange = 3
var _ready = false

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$Area2D.add_to_group("eol")
	pass

func _process(delta):
	# Not ready to end yet
	if !_ready:
		return
		
	# Wait
	if _sceneChange > 0:
		_sceneChange -= delta
		return
	
	# Show the first cutscene
	get_tree().change_scene("res://scenes/Complete.tscn")
	pass

func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	BeltRunner.emit_signal("eol")
	_ready = true
	pass
