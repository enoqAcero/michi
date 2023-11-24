extends Node2D

var rng = RandomNumberGenerator.new()

var gameRunning = false

var highScore = 0
var score = 0

var screenSize

var minJumpForce = 700
var newMinForce
var maxJumpForce = 5000
var jumpForce
var nextJumpForce
var minBounceFactor = 1
var bounceFactor
var prevBounceFactor
var readyToBounce = false
var bounceFactorControl = true
var multiplier : float
var multiplierCount
var clickControl = false

var michiStartPos = Vector2(240,600)
var posMichi = 0
var michiMinPos

var cameraStartPos = Vector2(240,427)
var cameraControl
var cameraUpControl = false
var cameraDownControl = false
var cameraStart = false
var cameraSpeed = 3
var cameraOffset = 0

var forceFunctionControl = true

var maxHeight

var falling = false
var michiPos
var prevMichiPos


#items
var coin = preload("res://Scenes/michiRun/coin.tscn")
var ball = preload("res://Scenes/michiRun/ball.tscn")
var brush = preload("res://Scenes/michiRun/brush.tscn")
var comb = preload("res://Scenes/michiRun/comb.tscn")
var fish = preload("res://Scenes/michiRun/fish.tscn")
var kibble = preload("res://Scenes/michiRun/kibble.tscn")
var laser = preload("res://Scenes/michiRun/laser.tscn")
var tuna = preload("res://Scenes/michiRun/tuna.tscn")
#obstacles
var wetSign = preload("res://Scenes/michiRun/wetSign.tscn")
var cactus = preload("res://Scenes/michiRun/cactus.tscn")
var poo = preload("res://Scenes/michiRun/poo.tscn")
var bee = preload("res://Scenes/michiJump/bee.tscn")
var baseball = preload("res://Scenes/michiRun/baseball.tscn")
var globo = preload("res://Scenes/michiRun/globo.tscn")

var items = []
var monedas
var itemCount = [0, 0, 0, 0, 0, 0, 0, 0]

#var Obstacles := [wetSign,cactus,poo,bee,baseball,globo]
var Obstacles := [bee]
var itemObstacles := [kibble, fish, tuna, ball, laser, comb, brush]

var obstaclesInstance : Array
var itemsInstance : Array

var controlObstacles = 0

func _ready():
	
	screenSize = get_window().size
	
	$Floor.get_node("Area2D").body_entered.connect(controlBounceEnter)
	$Floor.get_node("Area2D").body_exited.connect(controlBounceExit)
	$Floor.get_node("Area2D2").body_entered.connect(controlBounceHit)
	
	newGame()
	
func newGame():
	gameRunning = false
	get_tree().paused = false
	
	$Michi1.prevJumpForce = 700
	clickControl = false
	cameraStart = false
	falling = false
	michiPos = 0
	prevMichiPos = 0
	
	score = 0
	maxHeight = 0
	michiMinPos = 0
	multiplier = 1
	multiplierCount = 0
	cameraControl = 0
	controlObstacles = 0
	cameraOffset = 0
	
	jumpForce = minJumpForce
	newMinForce = minJumpForce
	nextJumpForce = jumpForce
	bounceFactor = minBounceFactor
	prevBounceFactor = bounceFactor
	
	for i in range (0, itemCount.size() - 1):
		itemCount[i] = 0
		
	#clear obstacles
	for obs in obstaclesInstance:
		obs.queue_free()
		obstaclesInstance.clear()
	for itm in itemsInstance:
		itm.queue_free()
		itemsInstance.clear()
	
	
	$Michi1.force(jumpForce)
	$Michi1.bFactor(bounceFactor)
	
	$Michi1.global_position = michiStartPos
	$Camera2D.global_position = cameraStartPos
	$CanvasLayer/score.text = "0"


func _process(_delta):
	if $Michi1.global_position.y > michiMinPos:
			michiMinPos = $Michi1.global_position.y
			
	if gameRunning == true:
		if cameraStart == false:
			if cameraUpControl == false:
				if Input.is_action_pressed("up"):
					cameraOffset -= cameraSpeed
			if cameraDownControl == false:
				if Input.is_action_pressed("down"):
					cameraOffset += cameraSpeed
			#cameraStart = true
			
			
		#ver si el michi esta saltando o cayendo
		if falling == false and posMichi > 2000:
			michiPos = -$Michi1.global_position.y
			if michiPos < prevMichiPos:
				print("Falling")
				falling = true
				
			prevMichiPos = michiPos
		#update maxHeight
		posMichi = ($Michi1.global_position.y - michiMinPos) * -1
		#borrar obstaculos 
		if falling == false:
			for obs in obstaclesInstance:
				obs.queue_free()
				obstaclesInstance.clear()
			for itm in itemsInstance:
				itm.queue_free()
				itemsInstance.clear()
		
		
		if falling == true and posMichi > 5000:
			if controlObstacles == 1:
				print("generateObs")
				generateObstacles()
				
	
		if posMichi > maxHeight:
			maxHeight = posMichi
			score = maxHeight/10
			
		
		if readyToBounce == true:
			#update bounce factor
			prevBounceFactor = bounceFactor
	
			if Input.is_action_just_pressed("click"):	
				if clickControl == false:
					bounceFactor += 0.2
					$Michi1.bControl(readyToBounce)
					bounceFactorControl = false
					multiplier = multiplier + 0.1
					multiplierCount = multiplierCount + 1
					clickControl = true
			if $Michi1.is_on_floor() and bounceFactorControl == true and bounceFactor <= prevBounceFactor:
				bounceFactor -= 0.15
				bounceFactorControl = false
				multiplier = 1
				multiplierCount = 0
				
			if bounceFactor < minBounceFactor:
				bounceFactor = minBounceFactor
			$Michi1.bFactor(bounceFactor)
			
			if multiplierCount > 0:
				var force = rng.randi_range(5,20)
				jumpForce = jumpForce + (force * multiplier)
				newMinForce = minJumpForce + jumpForce/5
			else:
				var force = rng.randi_range(10,20)
				jumpForce = jumpForce - force 
				newMinForce = minJumpForce + jumpForce/5
				
			if newMinForce < minJumpForce:
				newMinForce = minJumpForce
			if jumpForce > maxJumpForce:
				jumpForce = maxJumpForce
			if jumpForce < newMinForce:
				jumpForce = newMinForce
			$Michi1.force(jumpForce)
				
		
		

	
		#move camera
		if cameraControl == 1:
			$Camera2D.position.y = $Michi1.position.y + cameraOffset
		#update score
		$CanvasLayer/score.text = str(int(score))
		#update muliplier
		$CanvasLayer/multiplier.text = str(multiplierCount)
		#update floor distance
		$CanvasLayer/floorDistance.text = str(int(posMichi)/10)
	else:
		if Input.is_action_just_pressed("click"):
			gameRunning = true
			

func controlBounceEnter(body):
	if body.name == "Michi1":
		readyToBounce = true
	$CanvasLayer/floorDistance.label_settings.font_color = Color("#15fc00")
	
func controlBounceExit(body):
	if body.name == "Michi1":
		readyToBounce = false
		bounceFactorControl = true
		falling = false
		prevMichiPos = 0
		clickControl = false
		$Michi1.bControl(readyToBounce)
		
func controlBounceHit(body):
	if body.name == "Michi1":
		readyToBounce = false
	$CanvasLayer/floorDistance.label_settings.font_color = Color(1,1,1,1)
	if gameRunning == true:
		cameraControl = 1
		
func generateObstacles():
	if falling == true and controlObstacles == 1:
		randomize()
		
		var posX = 240#rng.randi_range(0, 100)
		#if posX > 50: posX = 480 + 50
		#else: posX = -50
		
		var posY = 2000 - posMichi
		
		
		var prob = rng.randi_range(0, 100)
		if prob < 300:
			var obs_type = Obstacles[randi() % Obstacles.size()]
			var obs = obs_type.instantiate()
			var obs_x = posX
			var obs_y = posY
			obs.global_position = Vector2(obs_x,obs_y)
			addObstacle(obs, 0)
		controlObstacles = 0
		
		
func addObstacle(obs, control : int):
	if control == 0:
		obs.body_entered.connect(hitObstacle)
		add_child(obs)
		obstaclesInstance.append(obs)
		print("obstacle added")
	else:
		obs.body_entered.connect(Callable(collect).bind(obs))
		add_child(obs)
		itemsInstance.append(obs)

func hitObstacle(body): 
	if body.name == "Michi1":
		#gameOver()	
		print("gameOver")
	
func collect(body, obs):
	if body.name == "michi":
		print("collectable")
		#if obs.is_in_group("item"):
			#for itm in itemsInstance:
				#if itm == obs:
					#handleItemCollection(itm)
					#break
		

func _on_obstacle_timer_timeout():
	if gameRunning == true:
		randomize()
		var minTime = 1
		var maxTime = 3
		controlObstacles = 1 
		$ObstacleTimer.set_wait_time(rng.randf_range(minTime, maxTime))

	


func _on_arriba_body_entered(body):
	if body.name == "Michi1":
		cameraDownControl = true

func _on_arriba_body_exited(body):
	if body.name == "Michi1":
		cameraDownControl = false

func _on_abajo_body_entered(body):
	if body.name == "Michi1":
		cameraUpControl = true
		
func _on_abajo_body_exited(body):
	if body.name == "Michi1":
		cameraUpControl = false
