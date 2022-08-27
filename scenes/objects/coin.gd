extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("coins")
	pass # Replace with function body.

func collect():
	$AnimationPlayer.playback_speed=2
	$CollisionShape2D.disabled=true
	$AnimationPlayer.play("collect")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collect":
		queue_free()
		
