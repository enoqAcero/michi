extends Control
var posMichi = Vector2(262,406)
var scaleMichi = 2.5
var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var huevoData = ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")
var rng = RandomNumberGenerator.new()
var probNewMichiType
var michiActual = null

func _ready():
	randomize()
	crearMichi()
	colorText()
	

func colorText():
	var richTextLabel = $labelcat
	var text = $labelcat.text
	var coloredText = ""
	var colors = ["#CCFF99", "#99FF99", "#99FFCC", "#99FFFF", "#FFFF99", "#ADFFSC", "#8FFF1F", "#99CCFF", "#FFCC99", "8F1FFF", "#AD5CFF"]
	

	for i in range(len(text)):
		var color = colors[i % colors.size()]
		coloredText += "[color=" + color + "]" + text[i] + "[/color]"

	coloredText = "[wave][center]" + coloredText + "[/center][/wave]"
	richTextLabel.bbcode_text = coloredText



func crearMichi():
	if michiActual != null:  # Si hay un Michi actual, lo eliminamos
		michiActual.queue_free()
		
	var michi
	probNewMichiType = rng.randi_range(1,5)
	if probNewMichiType == 1:
		michi = load("res://Michis/michiBlanco.tscn").instantiate()
		$labelcat.text ="Category 1 \n White"
	if probNewMichiType == 2:
		michi = load("res://Michis/michiCafe.tscn").instantiate()
		$labelcat.text ="Category 1 \n Brown"
	if probNewMichiType == 3:
		michi = load("res://Michis/michiGris.tscn").instantiate()
		$labelcat.text ="Category 1 \n Gray"
	if probNewMichiType == 4:
		michi = load("res://Michis/michiNaranja.tscn").instantiate()
		$labelcat.text ="Category 1 \n Orange"
	if probNewMichiType == 5:
		michi = load("res://Michis/michiNegro.tscn").instantiate()
		$labelcat.text ="Category 1 \n Black"


	
	michi.global_position = (posMichi)
	michi.scale.x= scaleMichi
	michi.scale.y= scaleMichi
	var michiSprite = michi.get_node("AnimatedSprite2D")
	michiSprite.play("Idle")
	var statusBall = michi.get_node("StatusGood")
	statusBall.visible = false
	add_child(michi)
	michiActual = michi  

func _on_hatch_b_pressed():
	GlobalVariables.probNewMichiType = probNewMichiType
	GlobalVariables.naceMichi = 1
	get_tree().paused= false
	save()
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")
	
	
func _on_video_b_pressed():
	probNewMichiType = rng.randi_range(1,5)
	crearMichi()
	colorText()



func save():
	ResourceSaver.save(huevoData, savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")




