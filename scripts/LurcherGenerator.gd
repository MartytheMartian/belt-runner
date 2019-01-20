extends Node2D

func _ready():
	BeltRunner.connect("lurcher", self, "_createLurcher")
	pass

#func _process(delta):
#	pass

func _createLurcher(position):
	# Build the lurcher
	var lurcher = preload("res://scenes/Lurcher.tscn").instance()
	
	# Set it's position
	lurcher.position = position
	
	# Spawn the lurcher
	add_child(lurcher)
	pass