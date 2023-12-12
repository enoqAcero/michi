extends Node2D

var michiInstance

var savePathHighScore = "res://Save/ChromeGame/"
var saveFileHighScore = "HighScoreSave"
var highScoreData = HighScore

var rng = RandomNumberGenerator.new()

var controlObstacles = 0
var wetSign = preload("res://Scenes/michiRun/wetSign.tscn")
var cactus = preload("res://Scenes/michiRun/cactus.tscn")
var poo = preload("res://Scenes/michiRun/poo.tscn")

var bee = preload("res://Scenes/michiRun/bee.tscn")
var baseball = preload("res://Scenes/michiRun/baseball.tscn")
var globo = preload("res://Scenes/michiRun/globo.tscn")

var items = []
var monedas : Monedero
var itemCount = [0, 0, 0, 0, 0, 0, 0, 0]

var coin = preload("res://Scenes/michiRun/coin.tscn")
var ball = preload("res://Scenes/michiRun/ball.tscn")
var brush = preload("res://Scenes/michiRun/brush.tscn")
var comb = preload("res://Scenes/michiRun/comb.tscn")
var fish = preload("res://Scenes/michiRun/fish.tscn")
var kibble = preload("res://Scenes/michiRun/kibble.tscn")
var laser = preload("res://Scenes/michiRun/laser.tscn")
var tuna = preload("res://Scenes/michiRun/tuna.tscn")






var groundObstacles := [wetSign,cactus,poo]
var flyObstacles := [bee,baseball,globo]
var itemObstacles := [kibble, fish, tuna, ball, laser, comb, brush]

var obstaclesInstance : Array
var itemsInstance : Array
var flyObstacleHeight := [239, 700]


var gameRunning = false
var michiSprite
var michiStartPos = Vector2(60, 790)
var floorStartPos = Vector2(0 ,0)
var cameraStartPos = Vector2(240, 427)

var speed : float
const startSpeed : float = 1.5
const maxSpeed : int = 7

var screenSize : Vector2
var score : float

var finalCoins = 0
var coinWonLabel



func _ready():
	GlobalVariables.michiSelected = false
	addMichi()
	
	loadData()
	loadItems()
	
	$Camera2D/Score.text = "0"
	screenSize = get_window().size
	$Camera2D/Control.get_node("VBoxContainer/HBoxContainer/Confirm").pressed.connect(playAgain)
	$Camera2D/Control.get_node("VBoxContainer/HBoxContainer/Cancel").pressed.connect(exit)
	$Camera2D/Control.get_node("VBoxContainer/Video").pressed.connect(video)
	
	coinWonLabel = $Camera2D/Control.get_node("VBoxContainer/HBoxContainer2/Label")
	
func newGame():
	$Camera2D/Control.visible = false
	$Label.visible = true
	get_tree().paused = false
	gameRunning = false
	
	speed = startSpeed
	score = 0
	controlObstacles = 0
	finalCoins = 0
	
	
	for i in range (0, itemCount.size() - 1):
		itemCount[i] = 0
	
	#reset the nodes
	$Camera2D/HighScore.text = str(highScoreData.highScore)
	$Camera2D/Score.text = "0"
	michiInstance.global_position = michiStartPos
	michiInstance.velocity = Vector2i(0, 0)
	$Floor.global_position = floorStartPos
	$Camera2D.global_position = cameraStartPos
	
	#clear obstacles
	for obs in obstaclesInstance:
		obs.queue_free()
	obstaclesInstance.clear()
	for itm in itemsInstance:
		itm.queue_free()
	itemsInstance.clear()
		
func _process(_delta):
	if gameRunning == true:
		$Label.visible = false
		michiSprite.play("WalkingSide")
		#update move speed
		speed = startSpeed + (score / 800)
		if speed > maxSpeed:
			speed = maxSpeed
		#generate obstacles and items
		if controlObstacles==1:
			generateObstacles()
		#move michi and camara
		michiInstance.position.x += speed
		$Camera2D.position.x += speed
		#$Floor.position.x += speed/2
		#update ground pos
		if $Camera2D.position.x - $Floor.position.x > screenSize.x * 1.5:
			$Floor.position.x += screenSize.x
		#remove obstacles from scene to clean up memory
		for obs in obstaclesInstance:
			if obs.position.x < ($Camera2D.position.x - screenSize.x):
				removeObstacle(obs, 0)
		for itm in itemsInstance:
			if itm.position.x < ($Camera2D.position.x - screenSize.x):
				removeObstacle(itm, 1)
		#update score
		score += speed / 10
		$Camera2D/Score.text = str(int(score))
	else:
		michiSprite.play("Idle")
		if Input.is_action_just_pressed("click"):
			gameRunning = true
			
func generateObstacles():
	if controlObstacles == 1:
		randomize()
		var prob = rng.randi_range(0, 100)
		if prob < 30:
			var obs_type = groundObstacles[randi() % groundObstacles.size()]
			var obs = obs_type.instantiate()
			var obs_x = screenSize.x + $Camera2D.position.x + 50
			var obs_y = 805
			obs.global_position = Vector2(obs_x,obs_y)
			addObstacle(obs, 0)
		elif prob >= 30 and prob <60:
			var obs_type = flyObstacles[randi() % groundObstacles.size()]
			var obs = obs_type.instantiate()
			var obs_x = screenSize.x + $Camera2D.position.x + 50
			var obs_y = rng.randi_range(flyObstacleHeight[0], flyObstacleHeight[1])
			obs.global_position = Vector2(obs_x,obs_y)
			addObstacle(obs, 0)
		elif prob >= 60 and prob <90:
			var prob2 = rng.randi_range(0, 100)
			var coinInstance = coin.instantiate()
			var coin_x = screenSize.x + $Camera2D.position.x + 50
			var coin_y = 805
			if prob2 > 50:
				coin_y = 805
			else:
				coin_y = rng.randi_range(flyObstacleHeight[0], flyObstacleHeight[1])
			coinInstance.global_position = Vector2(coin_x, coin_y)
			coinInstance.add_to_group("coin")
			coinInstance.add_to_group("item")
			addObstacle(coinInstance, 1)
		elif prob >=90:
			
			var prob2 = rng.randi_range(0, 100)
			var item_type = itemObstacles[randi() % itemObstacles.size()]
			var item = item_type.instantiate()
			var item_x = screenSize.x + $Camera2D.position.x + 50
			var item_y = 805
			if prob2 > 50:
				item_y = 805
			else:
				item_y = rng.randi_range(flyObstacleHeight[0], flyObstacleHeight[1])
			item.global_position = Vector2(item_x,item_y)
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
			for itm in itemsInstance:
				if itm == obs:
					handleItemCollection(itm)
					break
		
func handleItemCollection(item):
	var valorCoin = 1
	var valorItem = 1
	if item.is_in_group("coin"):
		print("moneda")
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
		
		
func gameOver():
	$Label.visible = false
	if highScoreData.highScore < score:
		highScoreData.highScore = score
		save()
	
	if score >= 10000: finalCoins = int((score/120) * 1.5)
	elif score >= 8000: finalCoins = int((score/120) * 1.4)
	elif score >= 6000: finalCoins = int((score/120) * 1.3)
	elif score >= 4000: finalCoins = int((score/120) * 1.2)
	elif score >= 2000: finalCoins = int((score/120) * 1.1)
	elif score < 2000: finalCoins = int(score/120)
	finalCoins += itemCount[0]
	coinWonLabel.text = str(finalCoins)
	
	$Camera2D/Control.visible = true
	get_tree().paused = true
	gameRunning = false




func _on_obstacle_timer_timeout():
	if gameRunning == true:
		randomize()
		var minTime = 1.5
		var maxTime = 3.5
		controlObstacles = 1 
		$ObstacleTimer.set_wait_time(rng.randf_range(minTime, maxTime))


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
	itemsCoinSave()
	GlobalVariables.michiSelected = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")

func addMichi():
	var michiScriptPath	= preload("res://Michis/Scripts/michiChromeGame.gd")
	var michiLoad = ResourceLoader.load(GlobalVariables.michiPath)
	var michi
	if michiLoad != null:
		michi = michiLoad.instantiate()
	michi.global_position = michiStartPos
	michi.scale = Vector2(1.5, 1.5)
	add_child(michi)
	michiInstance = michi
	michiInstance.name = "michi"
	
	michiInstance.set_script(michiScriptPath)
	michiInstance.get_node("CollisionPolygon2DNormal").disabled = true
	
	var statusBall = michiInstance.get_node("StatusGood")
	statusBall.visible = false
	michiSprite = michiInstance.get_node("AnimatedSprite2D")
	michiSprite.flip_h = true

	


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
	
	monedas.coin += finalCoins
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
	
func playAgain():
	itemsCoinSave()
	newGame()
	
func video():
	finalCoins = finalCoins * 2
	itemsCoinSave()
