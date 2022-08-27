extends Node2D

var elapsed = 0
var rotation_speed=PI/4
const COIN=preload("res://scenes/objects/coin.tscn")
const Bullet=preload("res://scenes/objects/bullet.tscn")
var dead = true
var offset = PI/6
var level = 1
var score = 0
var coin_group_size
signal coins_changed
var anima := Anima.begin(self)
var tween_playing=false

func shoot():
	var b = Bullet.instance()
	b.speed=clamp(((level-1)*10)+200,200,500)
	b.transform = $center.transform
	b.rotation+=(-rotation_speed/abs(rotation_speed))*-0.3
	b.rotation+= rand_range(-PI/5,PI/5)
	add_child(b)



func pre_start(params):
	randomize()
	self.connect("coins_changed", self, "_on_coins_changed")
	level=params.level
	$center.position=Game.size/2
	$center/pivot/ship.position.x=(Game.size.x*0.45) 
	$center/pivot/ship.rotation=PI/2 
	$center/pivot/ship/CollisionPolygon2D.disabled=true
	if params.has('ship'):
		score=params.score
		$center.rotation=params.ship.rotation
		$center/pivot/ship/shipSprite.flip_h=params.ship.flip
		rotation_speed=params.ship.speed


# `start()` is called when the graphic transition ends.
func start():
	print("gameplay.gd: start() called with level : ",level)
	if level ==1:
		$UI/cooldown.start()
	else:
#		$flash.start_flash(0.25,0.75)
#		yield(get_tree().create_timer(0.5), "timeout")
		$UI/level.text="Level "+str(level)
		$UI/level.visible=true
		anima.then(Anima.Node($UI/level).anima_animation("zoom_in",0.2).anima_on_completed(funcref(self, 'on_level_zoom_in'),[]))
		anima.play()
		
func on_level_zoom_in():
	yield(get_tree().create_timer(0.5), "timeout")
	$UI/level.visible=false
	begin_level()

func begin_level():
	dead=false
	coin_group_size=get_tree().get_nodes_in_group("coins").size()
	anima.then({node=$UI/score, animation = "tada", duration = 0.4, on_started = [funcref(self, '_on_tween_started'),[]],on_completed =[funcref(self, '_on_tween_completed'),[]]})	
	$center/pivot/ship/CollisionPolygon2D.disabled=false
	$Timer.start()
	$ParallaxBackground.start()

func _on_tween_started():
	tween_playing=true
func _on_tween_completed():
	tween_playing=false

func _process(delta):
#	$center/pivot.rotation+=rotation_speed*delta
#	print(get_tree().get_nodes_in_group("coins").size())
	if(!dead):
		$center.rotation+=rotation_speed*delta
		if coin_group_size != get_tree().get_nodes_in_group("coins").size():
			
			coin_group_size=get_tree().get_nodes_in_group("coins").size()
			emit_signal("coins_changed")
		
	
	
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			
			rotation_speed*=-1
			$center/pivot/ship/shipSprite.flip_h=!$center/pivot/ship/shipSprite.flip_h
			
func _draw():
	draw_circle_arc(Game.size/2,Game.size.x*0.45,0,360,Color.white)
#	draw_circle(Game.size/2,Game.size.x*0.7,Color.red)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 24
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var point=center + Vector2(cos(angle_point), sin(angle_point)) * radius
		points_arc.push_back(point)
		var coin=COIN.instance()
		coin.position=point
		coin.rotation=angle_point+ (PI/4)
		add_child(coin)
	for index_point in range(nb_points):
		
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)


# Replace with function body.
func add_score():
	score +=1
	$UI/score.text=str(score)
	if !tween_playing:
		anima.play()
	
	
func _on_ship_area_entered(area):
	if area.has_method("collect"):
		area.collect()
		add_score()
	if area.has_method("death"):
		$Timer.stop()
		$impactShaders.expand($center/pivot/ship.global_position)
		dead=true
		$ParallaxBackground.stop()

func _on_coins_changed():
	if coin_group_size == 0:
			Game.change_scene("res://scenes/gameplay/gameplay.tscn", 
			{
				"level":level+1,
				"score":score,
				"ship":
					{
						"flip":$center/pivot/ship/shipSprite.flip_h,
						"rotation":$center.rotation,
						"speed":rotation_speed
							}
							}
			)
	
func _on_Timer_timeout():
	shoot()


func _on_Control_finished():
	begin_level() # Replace with function body.




func _on_impactShaders_death_finished():
	$UI/score_label.visible=true
	$UI/Button.visible=true
	anima.then(Anima.Node($UI/score).anima_position_y((Game.size.y/2)-100,0.2))
	anima.with(Anima.Node($UI/score_label).anima_position_y((Game.size.y/2)-150,0.2))
	anima.with(Anima.Node($UI/Button).anima_position_y((Game.size.y/2),0.2))
	anima.play()


func _on_Button_pressed():
	Game.restart_scene() # Replace with function body.
