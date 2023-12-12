extends Control
var posMichi = Vector2(262,406)
var scaleMichi = 2.5
var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var huevoData
var rng = RandomNumberGenerator.new()
var probNewMichiType
var michiActual = null



func _ready():
	randomize()
	huevoData = ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")
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
	if huevoData.categoria == 1:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiBlanco.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n White"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiCafe.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Brown"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiGris.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Gray"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiNaranja.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Orange"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiNegro.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Black"
	if huevoData.categoria == 2:
		probNewMichiType = rng.randi_range(1,6)
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCalico.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Calico"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiEgipcio.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Sphynx"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiManchado.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Spoted"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPersa.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Persian"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSiames.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Siamese"
		if probNewMichiType == 6:
			michi = load("res://Michis/michiTabby.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Tabby"
	if huevoData.categoria == 3:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiBufanda.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Scarf"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiGirly.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Skirt"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiHipster.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Hipster"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiLentes.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Glasses"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiMonio.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Fancy"
	if huevoData.categoria == 4:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiArcoiris.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Rainbow"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiCristal.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cristal"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiDorado.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Gold"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiEstrellas.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Night Sky"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiNeon.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Neon"
	if huevoData.categoria == 5:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCaballero.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Knight"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiDragon.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Dragon"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiPrincesa.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Princes"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiUnicornio.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Unicorn"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSlime.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Slime"
	if huevoData.categoria == 6:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAgua.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Water"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiAire.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Air"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiAvatar.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Avatar"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiFuego.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Fire"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiTierra.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Earth"
	if huevoData.categoria == 7:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiChino.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Chinese New Year"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiHalloween.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Halloween"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiNavidad.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Christmas"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPascua.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Easter"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiStPatrick.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n St.Patrick"
	if huevoData.categoria == 8:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAlien.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Alien"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiAngel.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Angel"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiCyborg.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cyborg"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiDiablo.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Devil"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiZombie.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Zombie"
	if huevoData.categoria == 9:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCleopatra.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cleopatra"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiElvis.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Elvis"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiKhalo.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Khalo"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiMJ.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n MJ"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSwifty.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Swifty"
	if huevoData.categoria == 10:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCthulhu.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cthulhu"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiDracula.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Dracula"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Frankenstein"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiReyArturo.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n ReyArturo"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n SherlockHolmes"
	if huevoData.categoria == 11:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiEspadachin.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Espadachin"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiHechicero.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Hechicero"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiNinja.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Ninja"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPirata.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Pirata"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n SuperAlien"
	if huevoData.categoria == 12:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAladdin.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Aladdin"
		if probNewMichiType == 2:
			michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n BlancaNieves"
		if probNewMichiType == 3:
			michi = load("res://Michis/michiCenicienta.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cenicienta"
		if probNewMichiType == 4:
			michi = load("res://Michis/michiCheshire.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Cheshire"
		if probNewMichiType == 5:
			michi = load("res://Michis/michiRapunzel.tscn").instantiate()
			$labelcat.text ="Category " + str(huevoData.categoria) + "\n Rapunzel"


	
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
	GlobalVariables.michiCategory = huevoData.categoria
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




