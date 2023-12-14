extends Control

var getRoomNumber
var michiData
var michiNumber = GlobalVariables.michiNumber
var michiPath = GlobalVariables.michiPath
var michiPos = Vector2(218,50)
var michiInstance
var michiSprite
var roomNumber
var michiRoomNumber
var confirmLabel


func _ready():
	readyControl()
	GlobalVariables.michiSelected = true
	get_parent().get_node("prev").visible = false
	get_parent().get_node("next").visible = false
	get_tree().paused = true
	loadData()
	addMichi()

	
func loadData():
	michiData = ResourceLoader.load("res://Save/Michis/MichiSave" + str(michiNumber) + ".tres")
	getRoomNumber = ResourceLoader.load("res://Save/GUI/SaveGUIColor.tres")
	roomNumber = getRoomNumber.roomNumber
	michiRoomNumber = michiData.roomNumber
	$VBoxContainer/roomN.text = str(michiRoomNumber)
	
func readyControl():
	$Control.visible = false
	confirmLabel = $Control.get_node("VBoxContainer/Confirm/Label")
	confirmLabel.text = "Confirm"
	$Control.get_node("VBoxContainer/Confirm").pressed.connect(Confirm)
	$Control.get_node("VBoxContainer/Cancel").pressed.connect(Cancel)
	$Control.set_script(null)

	
func _process(_delta):
	print("MichPath: ", GlobalVariables.michiPath)
	
func addMichi():
	var michiScriptPath = preload("res://Michis/Scripts/michiIdle.gd")
	var michiLoad = ResourceLoader.load(GlobalVariables.michiPath)
	
	var michi
	michi = michiLoad.instantiate()
	michi.global_position = michiPos
	michi.scale = Vector2(1.6, 1.6)
	michi.z_index = 5
	michi.set_script(michiScriptPath)
	$VBoxContainer/HBoxContainer.add_child(michi)
	michiInstance = michi
	michiInstance.name = "michi"

	
	var statusBall = michiInstance.get_node("StatusGood")
	statusBall.visible = false
	michiSprite = michiInstance.get_node("AnimatedSprite2D")
	michiSprite.play("Idle")
	
	


func _on_prev_pressed():
	michiRoomNumber -= 1
	if michiRoomNumber <= 0:
		michiRoomNumber = 9
	$VBoxContainer/roomN.text = str(michiRoomNumber)
	

func _on_next_pressed():
	michiRoomNumber += 1
	if michiRoomNumber > 9:
		michiRoomNumber = 1
	$VBoxContainer/roomN.text = str(michiRoomNumber)
	
func _on_place_pressed():
	save(1)
	
func _on_place_go_pressed():
	save(2)
	
func _on_cancel_pressed():
	get_parent().get_node("prev").visible = true
	get_parent().get_node("next").visible = true
	get_tree().paused = false
	GlobalVariables.michiSelected = false
	queue_free()
	
	
func save(control : int):
	michiData.roomNumber = michiRoomNumber
	ResourceSaver.save(michiData,"res://Save/Michis/michiSave" + str(michiNumber) + ".tres")
	if control == 2:
		getRoomNumber.roomNumber = michiRoomNumber
		ResourceSaver.save(getRoomNumber,"res://Save/GUI/SaveGUIColor.tres")
		
	exit()
		
	
func exit():
	get_parent().get_node("prev").visible = true
	get_parent().get_node("next").visible = true
	get_tree().paused = false
	GlobalVariables.michiSelected = false
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")


func _on_release_pressed():
	$Control.visible = true
	
	
	
func Confirm():
	michiData.active = 0
	$Control.visible = false
	save(0)
	
func Cancel():
	$Control.visible = false
