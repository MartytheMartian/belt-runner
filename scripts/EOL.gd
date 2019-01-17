extends Node2D

func _ready():
	$Area2D.connect("area_entered", self, "_collide")
	$Area2D.add_to_group("eol")
	pass

func _collide(object):
	$Area2D/CollisionShape2D.disabled = true
	pass
