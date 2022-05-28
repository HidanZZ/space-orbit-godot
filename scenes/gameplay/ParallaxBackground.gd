extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export (float) var bg_speed=-1
var angle = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += bg_speed * delta;
	var offset = Vector2(sin(angle), cos(angle)) * Game.size.x;
	var pos = Game.size/2 + offset
	$ParallaxLayer.motion_offset= pos
	$ParallaxLayer2.motion_offset= pos
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			bg_speed*=-1
