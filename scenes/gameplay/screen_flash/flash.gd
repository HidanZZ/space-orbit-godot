extends Node2D
onready var tween_shake = $Tween
onready var flash_image=$Square

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func start_flash(speed,strength):
	tween_shake.interpolate_property(flash_image,"modulate:a",0,strength,speed,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween_shake.start()
	
	yield(get_tree().create_timer(speed),"timeout")
	tween_shake.interpolate_property(flash_image,"modulate:a",strength,0,speed,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween_shake.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
