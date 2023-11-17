extends Node2D

var michiInstance

var savePathHighScore = "res://Save/ChromeGame/"
var saveFileHighScore = "HighScoreSave"
var highScoreData = HighScore

var rng = RandomNumberGenerator.new()

var controlObstacles = 0
var obstacle1 = preload("res://Scenes/michiRun/Collision1.tscn")
var obstacle2 = preload("res://Scenes/michiRun/Collision2.tscn")
var obstacleTypes := [obstacle1, obstacle2]
var obstaclesInstance : Array
var flyObstacleHeight := [239, 700]
var lastObstacle

var gameRunning = false
var michiSprite
var michiStartPos = Vector2(60, 790)
var floorStartPos = Vector2(0 ,0)
var cameraStartPos = Vector2(240, 427)

var speed : float
const startSpeed : float = 1.5
const maxSpeed : int = 6

var screenSize : Vector2
var score : float


func _ready():
	addMichi()
	
	loadData()
	
	$Camera2D/Score.text = "0"
	screenSize = get_window().size
	$Camera2D/Control.get_node("VBoxContainer/Confirm").pressed.connect(newGame)
	$Camera2D/Control.get_node("VBoxContainer/Cancel").pressed.connect(exit)
	
func newGame():
	$Camera2D/Control.visible = false
	get_tree().paused = false
	gameRunning = false
	
	speed = startSpeed
	score = 0
	
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
		
func _process(_delta):
	if gameRunning == true:
		michiSprite.play("WalkingSide")
		#update move speed
		speed = startSpeed + (score / 700)
		if speed > maxSpeed:
			speed = maxSpeed
		#generate obstacles
		generateObstacles()
		#move michi and camara
		michiInstance.position.x += speed
		$Camera2D.position.x += speed
		#update ground pos
		if $Camera2D.position.x - $Floor.position.x > screenSize.x * 1.5:
			$Floor.position.x += screenSize.x
		#remove obstacles from scene to clean up memory
		for obs in obstaclesInstance:
			if obs.position.x < ($Camera2D.position.x - screenSize.x):
				removeObstacle(obs)
		#update score
		score += speed / 10
		$Camera2D/Score.text = str(int(score))
	else:
		michiSprite.play("Idle")
		if Input.is_action_just_pressed("click"):
			gameRunning = true
			
func generateObstacles():
	var control = 0
	if controlObstacles == 1:
		randomize()
		var prob = rng.randi_range(1, 100)
		if prob <= 50:
			var obs_type = obstacleTypes[randi() % obstacleTypes.size()]
			var obs = obs_type.instantiate()
			var obs_x = screenSize.x + $Camera2D.position.x + 50
			var obs_y = 805
			obs.global_position = Vector2(obs_x,obs_y)
			control = 1
			addObstacle(obs)
		elif prob > 50 and control == 0:
			var obs = obstacle1.instantiate()
			var obs_x = screenSize.x + $Camera2D.position.x + 50
			var obs_y = rng.randi_range(flyObstacleHeight[0], flyObstacleHeight[1])
			obs.global_position = Vector2(obs_x,obs_y)
			addObstacle(obs)
		controlObstacles = 0
		
func addObstacle(obs):
	obs.body_entered.connect(hitObstacle)
	lastObstacle = obs
	add_child(obs)
	obstaclesInstance.append(obs)

func removeObstacle(obs):
	obs.queue_free()
	obstaclesInstance.erase(obs)
	
func hitObstacle(body):
	if body.name == "michi":
		gameOver()

func gameOver():
	if highScoreData.highScore < score:
		highScoreData.highScore = score
		save()
		
	$Camera2D/Control.visible = true
	get_tree().paused = true
	gameRunning = false



func _on_obstacle_timer_timeout():
	if gameRunning == true:
		randomize()
		var minTime = 1
		var maxTime = 2
		controlObstacles = 1 
		generateObstacles()
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
	SignalManager.changeMichiScriptToMain.emit()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")

func addMichi():
	var michiScriptPath	= preload("res://Michis/Scripts/michiChromeGame.gd")
	var michiLoad = ResourceLoader.load(GlobalVariables.michiPath)
	var michi
	if michiLoad != null:
		michi = michiLoad.instantiate()
	michi.global_position = Vector2(60, 790)
	michi.scale = Vector2(1.5, 1.5)
	add_child(michi)
	michiInstance = michi
	michiInstance.name = "michi"
	
	michiInstance.set_script(michiScriptPath)
	
	var statusBall = michiInstance.get_node("StatusGood")
	statusBall.visible = false
	michiSprite = michiInstance.get_node("AnimatedSprite2D")
	michiSprite.flip_h = true

	
