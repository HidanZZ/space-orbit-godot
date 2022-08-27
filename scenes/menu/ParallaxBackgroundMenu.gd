extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export (float) var bg_speed=0.2
var angle = 0
var start = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += bg_speed * delta;
	var offset = Vector2(angle,angle) * Game.size.x;
	var pos = Game.size/2 + offset
	$ParallaxLayer.motion_offset= pos
	$ParallaxLayer2.motion_offset= pos

