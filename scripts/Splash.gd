extends Node

var _done = false
var _hang = 2

func _ready():
	$Panel/AnimationPlayer.connect("animation_finished", self, "_animation_finished")
	pass

func _process(delta):
	if !_done:
		return
		
	if _hang > 0:
		_hang -= delta
		return
		
	$Panel/AnimationPlayer.play("Unload")
	_done = false
	pass
	
func _animation_finished(animation):
	# Start unloading
	if animation == "Load":
		_done = true
		return
	
	# Go to the main menu
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	pass
