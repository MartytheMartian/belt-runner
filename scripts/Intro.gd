extends Node

var scenechange = 3

func _ready():
	pass

func _process(delta):
	# Reduce the timer and return if not time
	if scenechange > 0:
		scenechange -= delta
		return
		
	# Reset the timer
	scenechange = 3
		
	# Show panel 2
	if $Panel1.visible:
		$Panel1.visible = false
		$Panel2.visible = true
		return
		
	# Show the first cutscene
	get_tree().change_scene("res://scenes/Level1.tscn")
	pass
