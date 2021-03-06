extends Node2D

var elapsed = 0
var rotation_speed=PI/3
# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
#	var cur_scene: Node = get_tree().current_scene
#	print("Current scene is: ", cur_scene.name, " (", cur_scene.filename, ")")
#	print("gameplay.gd: pre_start() called with params = ")
#	if params:
#		for key in params:
#			var val = params[key]
#			printt("", key, val)
#	print("Processing...")
##	yield(get_tree().create_timer(2), "timeout")
#	print("Done")
	$center.position=Game.size/2
	$center/pivot/ship.position.y=-(Game.size.x*0.7) 


# `start()` is called when the graphic transition ends.
func start():
	print("gameplay.gd: start() called")


func _process(delta):
#	$center/pivot.rotation+=rotation_speed*delta
	$center.rotation+=rotation_speed*delta
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			rotation_speed*=-1
			$center/pivot/ship.flip_h=!$center/pivot/ship.flip_h
