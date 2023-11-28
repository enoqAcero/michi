extends Node2D

var rng = RandomNumberGenerator.new()

var michiInstance
var michiSprite
var michiStartPos = Vector2(240,600)
var paraguasSprite
var fuegoSprite

var trampolineSprite

var savePathHighScore = "res://Save/MichiJump/"
var saveFileHighScore = "HighScoreSave"
var highScoreData = HighScore

var gameRunning = false

var highScore = 0
var score = 0

var screenSize : Vector2

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
var fallingControl = false
var goingUpControl = false
var michiPos
var prevMichiPos


#items
var coin = preload("res://Scenes/michiJump/coin.tscn")
var ball = preload("res://Scenes/michiJump/ball.tscn")
var brush = preload("res://Scenes/michiJump/brush.tscn")
var comb = preload("res://Scenes/michiJump/comb.tscn")
var fish = preload("res://Scenes/michiJump/fish.tscn")
var kibble = preload("res://Scenes/michiJump/kibble.tscn")
var laser = preload("res://Scenes/michiJump/laser.tscn")
var tuna = preload("res://Scenes/michiJump/tuna.tscn")
#obstacles
var obs1 = preload("res://Scenes/michiJump/obs1.tscn")
var obs2 = preload("res://Scenes/michiJump/obs2.tscn")
var obs3 = preload("res://Scenes/michiJump/obs3.tscn")


var items = []
var monedas : Monedero
var itemCount = [0, 0, 0, 0, 0, 0, 0, 0]

#var Obstacles := [wetSign,cactus,poo,bee,baseball,globo]
var Obstacles := [obs1, obs2, obs3]
var itemObstacles := [kibble, fish, tuna, ball, laser, comb, brush]

var obstaclesInstance : Array
var itemsInstance : Array

var obstacleXpos := [20, 460]
var controlObstacles = 0

func _ready():
	addMichi()
	
	loadData()
	loadItems()
	
	trampolineSprite = $Floor.get_node("AnimatedSprite2D")
	screenSize = get_window().size
	
	$Floor.get_node("Area2D").body_entered.connect(controlBounceEnter)
	$Floor.get_node("Area2D").body_exited.connect(controlBounceExit)
	$Floor.get_node("Area2D2").body_entered.connect(controlBounceHit)
	$Floor.get_node("Area2D3").body_entered.connect(controlAnimationEnter)
	$Floor.get_node("Area2D3").body_exited.connect(controlAnimationExit)
	
	$CanvasLayer/Control.get_node("VBoxContainer/Confirm").pressed.connect(newGame)
	$CanvasLayer/Control.get_node("VBoxContainer/Cancel").pressed.connect(exit)
	
	
	
func newGame():
	gameRunning = false
	get_tree().paused = false
	
	$CanvasLayer/Control.visible = false
	
	michiInstance.prevJumpForce = 700
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
	
	
	michiInstance.force(jumpForce)
	michiInstance.bFactor(bounceFactor)
	
	michiInstance.global_position = michiStartPos
	$Camera2D.global_position = cameraStartPos
	$CanvasLayer/score.text = "0"
	$CanvasLayer/multiplier.text = "0"
	$CanvasLayer/floorDistance.text = "0"
	$CanvasLayer/highScore.text = str(highScoreData.highScore)
	
	michiSprite.play("WalkingDown")


func _process(_delta):
	if michiInstance.global_position.y > michiMinPos:
			michiMinPos = michiInstance.global_position.y
			
	if gameRunning == true:
		if cameraStart == false:
			if cameraUpControl == false:
				if Input.is_action_pressed("up"):
					cameraOffset -= cameraSpeed
			if cameraDownControl == false:
				if Input.is_action_pressed("down"):
					cameraOffset += cameraSpeed

		if falling == false and posMichi > 500:
			getFallingStatus()	
			
		
	
		#calcular la pos actual de michi con respecto al suelo
		posMichi = (michiInstance.global_position.y - michiMinPos) * -1
		#borrar obstaculos 
		if readyToBounce == true:
			cleanObstacles()
			
			
		if falling == true and posMichi > 5500:
			if controlObstacles == 1:
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
					michiInstance.bControl(readyToBounce)
					bounceFactorControl = false
					multiplier = multiplier + 0.1
					multiplierCount = multiplierCount + 1
					clickControl = true
			if michiInstance.is_on_floor() and bounceFactorControl == true and bounceFactor <= prevBounceFactor:
				bounceFactor -= 0.15
				bounceFactorControl = false
				multiplier = 1
				multiplierCount = 0
				
			if bounceFactor < minBounceFactor:
				bounceFactor = minBounceFactor
			michiInstance.bFactor(bounceFactor)
			
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
			michiInstance.force(jumpForce)
				
		
		for obs in obstaclesInstance:
			if obs.position.y < ($Camera2D.position.y - screenSize.y):
				removeObstacle(obs, 0)

		for itm in itemsInstance:
			if itm.position.y < ($Camera2D.position.y - screenSize.y):
				removeObstacle(itm, 1)

		if posMichi > 500 and falling == false and goingUpControl == false:
			goingUp()
			
			
		if falling == true and fallingControl == false:
			goingDown()
	
		#move camera
		if cameraControl == 1:
			$Camera2D.position.y = michiInstance.position.y + cameraOffset
		#update score
		$CanvasLayer/score.text = str(int(score))
		#update muliplier
		$CanvasLayer/multiplier.text = str(multiplierCount)
		#update floor distance
		$CanvasLayer/floorDistance.text = str(int(posMichi)/10)
	else:
		if Input.is_action_just_pressed("click"):
			gameRunning = true
			
func getFallingStatus():
#ver si el michi esta saltando o cayendo
	michiPos = -michiInstance.global_position.y
	if michiPos <= 0: michiPos = 1
	if michiPos < prevMichiPos:
		falling = true
		print("Faaaaallling")
	prevMichiPos = michiPos
	
	
func cleanObstacles():
	for obs in obstaclesInstance:
		obs.queue_free()
	obstaclesInstance.clear()
	for itm in itemsInstance:
		itm.queue_free()
	itemsInstance.clear()		

func goingUp():
	michiInstance.scale.x = 1.4
	michiInstance.scale.y = 1.6
	michiSprite.play("WalkingUp")
	paraguasSprite.visible = false
	goingUpControl = true
	
	if not multiplierCount == 0:
		fuegoSprite.visible = true
		
	if multiplierCount == 1:
		fuegoSprite.visible = true
		fuegoSprite.modulate = Color("#ffffff")
	elif multiplierCount == 2:
		fuegoSprite.visible = true
		fuegoSprite.modulate = Color("#ffffab")
	elif multiplierCount == 3:
		fuegoSprite.modulate = Color("#ff775c")
	elif multiplierCount == 4:
		fuegoSprite.modulate = Color("#ff0000")
	elif multiplierCount == 5:
		fuegoSprite.modulate = Color("#f000be")
		
	
	
	
func controlBounceEnter(body):
	if body.name == "michi":
		readyToBounce = true
		$CanvasLayer/floorDistance.label_settings.font_color = Color("#15fc00")
	
func controlBounceExit(body):
	if body.name == "michi":
		readyToBounce = false
		bounceFactorControl = true
		falling = false
		prevMichiPos = 0
		clickControl = false
		fallingControl = false
		michiInstance.bControl(readyToBounce)
		
func controlBounceHit(body):
	if body.name == "michi":
		readyToBounce = false
		$CanvasLayer/floorDistance.label_settings.font_color = Color(1,1,1,1)
		if gameRunning == true:
			cameraControl = 1
		
func controlAnimationEnter(body):
	if body.name == "michi":
		michiInstance.scale.x = 1.8
		michiInstance.scale.y = 0.8
		trampolineSprite.play("jump")
func controlAnimationExit(body):
	if body.name == "michi":
		michiInstance.scale.x = 1.5
		michiInstance.scale.y = 1.5
func generateObstacles():
	if falling == true and controlObstacles == 1:
		randomize()
		
		var posX = rng.randi_range(obstacleXpos[0], obstacleXpos[1])
		var posY = 2000 - posMichi
		
		
		var prob = rng.randi_range(0, 1000)
		if prob < 70:
			var obs_type = Obstacles[randi() % Obstacles.size()]
			var obs = obs_type.instantiate()
			var obs_x = posX
			var obs_y = posY
			obs.global_position = Vector2(obs_x,obs_y)
			obs.speedY = rng.randi_range(2, 4)
			var hue = posMichi/float(score)
			var color = Color.from_hsv(hue,1,1)
			obs.modulate = color
			addObstacle(obs, 0)
		elif prob > 100:#>=70 and prob < 95:
			var coinInstance = coin.instantiate()
			coinInstance.global_position = Vector2(posX, posY)
			coinInstance.speedY = rng.randi_range(2, 4)
			coinInstance.add_to_group("item")
			coinInstance.add_to_group("coin")
			addObstacle(coinInstance, 1)
		elif prob >=95 and prob <=100:
			var item_type = itemObstacles[randi() % itemObstacles.size()]
			var item = item_type.instantiate()
			item.speedY = rng.randi_range(2, 4)
			item.global_position = Vector2(posX,posY)
			item.add_to_group("item")
			
			if item.name == "ball":
				item.add_to_group("ball")
			if item.name == "brush":
				item.add_to_group("brush")
			if item.name == "comb":
				item.add_to_group("comb")
			if item.name == "fish":
				item.add_to_group("fish")
			if item.name == "kibble":
				item.add_to_group("kibble")
			if item.name == "laser":
				item.add_to_group("laser")
			if item.name == "tuna":
				item.add_to_group("tuna")
	
			addObstacle(item, 1)
			
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

func removeObstacle(obs, control : int):
	if control == 0:
		obs.queue_free()
		obstaclesInstance.erase(obs)
	else:
		obs.queue_free()
		itemsInstance.erase(obs)
		
func hitObstacle(body): 
	if body.name == "michi":
		gameOver()	
	
func collect(body, obs):
	if body.name == "michi":
		if obs.is_in_group("item"):
			print("collectable itme")
			for itm in itemsInstance:
				if itm == obs:
					handleItemCollection(itm)
					break
		
func handleItemCollection(item):
	var valorCoin = 1
	var valorItem = 1
	if item.is_in_group("coin"):
		removeObstacle(item, 1)
		itemCount[0] += valorCoin
	elif item.is_in_group("kibble"):
		itemCount[1] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("fish"):
		itemCount[2] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("tuna"):
		itemCount[3] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("ball"):
		itemCount[4] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("laser"):
		itemCount[5] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("comb"):
		itemCount[6] += valorItem
		removeObstacle(item, 1)
	elif item.is_in_group("brush"):
		itemCount[7] += valorItem
		removeObstacle(item, 1)
		
func _on_obstacle_timer_timeout():
	if gameRunning == true:
		randomize()
		var minTime = 0.3
		var maxTime = 1.5
		controlObstacles = 1 
		$ObstacleTimer.set_wait_time(rng.randf_range(minTime, maxTime))
		
		
func gameOver():
	if highScoreData.highScore < score:
		highScoreData.highScore = score
		save()
	var wait = 1
	wait = itemsCoinSave()
	if wait == 1: 
		$CanvasLayer/Control.visible = true
		get_tree().paused = true
		gameRunning = false

func loadData():
	if ResourceLoader.exists(savePathHighScore + saveFileHighScore + ".tres"):
		highScoreData = ResourceLoader.load(savePathHighScore + saveFileHighScore + ".tres")
	else:
		var newHighScoreData = HighScore.new()
		ResourceSaver.save(newHighScoreData, (savePathHighScore + saveFileHighScore + ".tres" ))
		highScoreData = ResourceLoader.load(savePathHighScore + saveFileHighScore + ".tres")
		
	newGame()
	
func save():
	ResourceSaver.save(highScoreData, savePathHighScore + saveFileHighScore + ".tres")
	
func exit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")


func _on_arriba_body_entered(body):
	if body.name == "michi":
		cameraDownControl = true

func _on_arriba_body_exited(body):
	if body.name == "michi":
		cameraDownControl = false

func _on_abajo_body_entered(body):
	if body.name == "michi":
		cameraUpControl = true
		
func _on_abajo_body_exited(body):
	if body.name == "michi":
		cameraUpControl = false
		
func addMichi():
	var michiScriptPath	= preload("res://Michis/Scripts/michiJumpGame.gd")
	var paraguasPath = preload("res://Scenes/michiJump/paraguas.tscn")
	var fuegoPath = preload("res://Scenes/michiJump/fuego.tscn")
	
	var michiLoad = ResourceLoader.load(GlobalVariables.michiPath)
	var paraguas = paraguasPath.instantiate()
	var fuego = fuegoPath.instantiate()
	
	var michi
	if michiLoad != null:
		michi = michiLoad.instantiate()
	michi.global_position = michiStartPos
	michi.scale = Vector2(1.5, 1.5)
	michi.z_index = 3
	add_child(michi)
	michiInstance = michi
	michiInstance.name = "michi"
	
	paraguas.global_position = Vector2(-9,-31)
	paraguas.name = "paraguas"
	paraguas.z_index = 2
	michiInstance.add_child(paraguas)
	
	fuego.global_position = Vector2(-5,13)
	fuego.name = "fuego"
	fuego.z_index = 1
	michiInstance.add_child(fuego)
	
	
	michiInstance.set_script(michiScriptPath)
	
	var statusBall = michiInstance.get_node("StatusGood")
	
	paraguasSprite = michiInstance.get_node("paraguas").get_node("AnimatedSprite2D")
	paraguasSprite.visible = false
	
	fuegoSprite = michiInstance.get_node("fuego").get_node("AnimatedSprite2D")
	fuegoSprite.visible = false
	
	statusBall.visible = false
	michiSprite = michiInstance.get_node("AnimatedSprite2D")
	michiSprite.play("WalkingDown")


func goingDown():
	michiSprite.stop()
	michiInstance.scale.x = 1.5
	michiInstance.scale.y = 1.5
	michiSprite.play("WalkingDown")
	paraguasSprite.visible = true
	paraguasSprite.play("default")
	fallingControl = true
	goingUpControl = false
	fuegoSprite.visible = false



func loadItems():
	monedas = ResourceLoader.load ("res://Save/moneditas.tres")
	for i in range (0,7):
		if i == 0: items.append(ResourceLoader.load ("res://Save/kibble_item.tres"))
		if i == 1: items.append(ResourceLoader.load ("res://Save/fish_item.tres"))
		if i == 2: items.append(ResourceLoader.load ("res://Save/tunacan_item.tres"))
		if i == 3: items.append(ResourceLoader.load ("res://Save/ball_item.tres"))
		if i == 4: items.append(ResourceLoader.load ("res://Save/laser_item.tres"))
		if i == 5: items.append(ResourceLoader.load ("res://Save/comb_item.tres"))
		if i == 6: items.append(ResourceLoader.load ("res://Save/brush_item.tres"))
		
		
func itemsCoinSave():
	
	monedas.coin += itemCount[0]
	for i in range(0, itemCount.size() - 1):
		items[i].count += itemCount[i+1]
		
	ResourceSaver.save(monedas, "res://Save/moneditas.tres")
	ResourceSaver.save(items[0], "res://Save/kibble_item.tres")
	ResourceSaver.save(items[1], "res://Save/fish_item.tres") 
	ResourceSaver.save(items[2], "res://Save/tunacan_item.tres") 
	ResourceSaver.save(items[3], "res://Save/ball_item.tres") 
	ResourceSaver.save(items[4], "res://Save/laser_item.tres") 
	ResourceSaver.save(items[5], "res://Save/comb_item.tres") 
	ResourceSaver.save(items[6], "res://Save/brush_item.tres") 
	
	return 1
