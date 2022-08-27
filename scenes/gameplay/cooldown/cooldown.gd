extends Control

signal finished
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer=3 setget setTimer
var anima := Anima.begin(self)
# Called when the node enters the scene tree for the first time.
func setTimer(val):
	timer=val
	$Label.text=str(timer)

func _ready():
#	visible=false
	setTimer(3)
	anima.then(Anima.Node($Label) \
	  .anima_animation("bouncing_in", 0.5))
	anima.then(Anima.Node($Label) \
	  .anima_animation("bounce_out", 0.5).anima_on_completed(funcref(self, '_on_anim_completed'),[1])) # Replace with function body.
#	anima.then({node=$Label, animation= "bounce_out", duration=1 ,on_completed = [funcref(self, '_on_anim_completed'),[1]] }) # Replace with function body.

func _on_anim_completed(val):
	print("here ",timer ," "+str(val))
#	anima.stop()
	setTimer(timer-1)
	if timer<= 0:
		$Label.text="GO"
	if timer<0:
			visible=false
			emit_signal("finished")
	else:
		anima.play()
	
	

func start():
	visible=true
	anima.play()
	print(timer)
	
#func _input(event):
#	if event is InputEventMouseButton:
#		if event.is_pressed():
#			print('ss')
#			start()



func _on_Timer_timeout():
	yield(get_tree().create_timer(0.5), "timeout")
	visible=false
	emit_signal("finished")
