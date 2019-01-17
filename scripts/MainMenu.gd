extends Node

func _ready():
	# Move the new button to the continue position if necessary
	if (true):
		$New.rect_position = $Continue.rect_position
		$Continue.hide()
	
	$Continue.connect("pressed", self, "cont")
	$New.connect("pressed", self, "new")
	pass

func _process(delta):
	
	pass

func cont():
	
	pass
	
func new():
	# TODO: Delete the existing save game
	
	# Show the first cutscene
	get_tree().change_scene("res://cutscenes/Intro.tscn")
	pass