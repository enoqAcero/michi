extends Node2D
#var furnitureResource = preload("res://Save/Furniture/furnitureSave.tres")
var getRoomNumber : ColorGUI
var roomNumber
#variables para posicionar los michis y huevos
var rng = RandomNumberGenerator.new()
var pos_x
var pos_y
var textureHeart = preload("res://Michis/Status/Assets/statusHeart.png")
var textureBall = preload("res://Michis/Status/Assets/statusWhite.png")
#variables para guardar datos
var savePathMichi = "res://Save/Michis/"
var saveFileNameMichi = "MichiSave"
var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var savePathPis = "res://Save/Pis/"
var saveFileNamePis = "PisSave"
var savePathPoop = "res://Save/Poop/"
var saveFileNamePoop = "PoopSave"
var savePathColorGui = "res://Save/GUI/"
var saveFileColorGui= "SaveGUIColor"
var furnitureData : furniture
var furnitureInstance = []
var furnitureInstanceId = 0
#guardad que tipo de objeto se esta seleccionando
var type = 0
#crea michis del 0 al maxMichiNumber -1 y guardar en array de tipo MichiData. si maxMichiNumber = 5 crea en total 5 michis
var michiData : Array[MichiData]
var michiNumber = 0
var maxMichiNumber = GlobalVariables.maxMichiNumber
var michiInstance = []
#crea huevos del 0 al maxHuevoNumber - 1 y guardar en array de tipo HuevoData. si maxHuevoNumber = 5 crea en total 5 huevos
var huevoData : Array[HuevoData]
var huevoNumber = 0
var maxHuevoNumber = GlobalVariables.maxHuevoNumber
var huevoInstance = []
#variables para la pis
var pisData : Array[PisData]
var pisInstance = []
var pisNumber = 0
var maxPisNumber = GlobalVariables.maxPisNumber
#variables para la mierda
var poopData : Array[PoopData]
var poopInstance = []
var poopNumber = 0
var maxPoopNumber = GlobalVariables.maxPoopNumber

#variable para detectar la senial de ambos michis al ser fucionados
var michiN2
var otherMichiN = 100
var otherMichiN2

var confirmInstance = []
var confirmN = -1
var sceneConfirmControl = 0 

var confirmPlayInstance
var controlConfirmPlayInstance = 1
var confirmChangeRoom
var controlMichiChangeRoom = 1

var coinInstance : Array
var timerCoinInstance : Array

var tiempo = 0.0
var caminadora
var caminadoraLuz
var brincolinLuz
var brincolin
var nuevoNombre
var pisCounter = 0
var poopCounter = 0

var animationControl = true
var doubleClick = false
var clickCount = 0

var btnControl = false
var stopJoyStick = false

func _ready():
	$JoyStickTest.visible = false
	randomize()
	
	$Transition/ColorRect.self_modulate = Color("#ffffff")
	$Transition/ColorRect.visible = true
	$Transition.play("fadeIn")
	
	GlobalVariables.michiSelected = false
	GlobalVariables.itemSelected = false
	GlobalVariables.michiHover = false
	
	AgregarTodo()
	caminadoraLuz = $Caminadora3000Azul.get_node("PointLight2D")
	brincolinLuz = $jumper3000.get_node("PointLight2D")
	
	caminadora = $Caminadora3000Azul.get_node("Area2D")
	caminadora.body_entered.connect(michiRunner)
	brincolin = $jumper3000.get_node("Area2D")
	brincolin.body_entered.connect(michiJumper)
	
	SignalManager.muebleSignal.connect(ponerMueble, 0)
	SignalManager.michiNumber.connect(getNumber, 0)
	SignalManager.huevoNumber.connect(getNumber, 1)
	SignalManager.merge.connect(merge)
	SignalManager.mergeConfirm.connect(confirmarMerge)
	SignalManager.michiEggShowHide.connect(michiEggShowHide)
	SignalManager.updateMichiStatus.connect(updateMichiStatus)
	SignalManager.save.connect(save)
	SignalManager.confirmPlay.connect(confirmPlay)
	SignalManager.pisNumber.connect(getNumber, 2)
	SignalManager.poopNumber.connect(getNumber, 3)
	SignalManager.poopAndPee.connect(poopAndPee)
	SignalManager.globalTimer1.connect(updateMichiStatusBars)
	SignalManager.restComfort.connect(restComfort)
	
func AgregarTodo():
	#poner todas la pis
	for i in range(0, maxPisNumber):
		var pis = load("res://Interactives/pis.tscn").instantiate()
		pis.global_position = pisData[i].globalPos
		pis.name = ("pis"+str(i))
		pis.z_index = 1
		if pisData[i].active == 1 and pisData[i].roomNumber == roomNumber:
			pisCounter += 1
			add_child(pis)
		pisInstance.append(pis)
		
	#poner todas las mierdas
	for i in range(0, maxPoopNumber):
		var poop = load("res://Interactives/PoopRigidBody2D.tscn").instantiate()
		poop.global_position = poopData[i].globalPos
		poop.name = ("poop"+str(i))
		poop.z_index = 1
		if poopData[i].active == 1 and poopData[i].roomNumber == roomNumber:
			poopCounter += 1
			add_child(poop)
		poopInstance.append(poop)
	
	
	#poner todos los michis en escena	
	for i in range(0, maxMichiNumber): 
		var michi = load("res://Michis/michiNaranja.tscn").instantiate()
		
		#cargar todos los michis de la primera categoria
		if michiData[i].categoryLevel == 1:
			if michiData[i].type == "Naranja":
				michi = load("res://Michis/michiNaranja.tscn").instantiate()
			if michiData[i].type == "Negro":
				michi = load("res://Michis/michiNegro.tscn").instantiate()
			if michiData[i].type == "Gris":
				michi = load("res://Michis/michiGris.tscn").instantiate()
			if michiData[i].type == "Cafe":
				michi = load("res://Michis/michiCafe.tscn").instantiate()
			if michiData[i].type == "Blanco":
				michi = load("res://Michis/michiBlanco.tscn").instantiate()
		#cargar todos los michis de la segunda categoria
		elif michiData[i].categoryLevel == 2:
			if michiData[i].type == "Tabby":
				michi = load("res://Michis/michiTabby.tscn").instantiate()
			if michiData[i].type == "Siames":
				michi = load("res://Michis/michiSiames.tscn").instantiate()
			if michiData[i].type == "Persa":
				michi = load("res://Michis/michiPersa.tscn").instantiate()
			if michiData[i].type == "Manchado":
				michi = load("res://Michis/michiManchado.tscn").instantiate()
			if michiData[i].type == "Egipcio":
				michi = load("res://Michis/michiEgipcio.tscn").instantiate()
			if michiData[i].type == "Calico":
				michi = load("res://Michis/michiCalico.tscn").instantiate()
		#cargar todos los michis de la tercera categoria
		elif michiData[i].categoryLevel == 3:
			if michiData[i].type == "Bufanda":
				michi = load("res://Michis/michiBufanda.tscn").instantiate()
			if michiData[i].type == "Girly":
				michi = load("res://Michis/michiGirly.tscn").instantiate()
			if michiData[i].type == "Hipster":
				michi = load("res://Michis/michiHipster.tscn").instantiate()
			if michiData[i].type == "Lentes":
				michi = load("res://Michis/michiLentes.tscn").instantiate()
			if michiData[i].type == "Monio":
				michi = load("res://Michis/michiMonio.tscn").instantiate()
		#cargar todos los michis de la cuarta categoria
		elif michiData[i].categoryLevel == 4:
			if michiData[i].type == "Neon":
				michi = load("res://Michis/michiNeon.tscn").instantiate()
			if michiData[i].type == "Estrellas":
				michi = load("res://Michis/michiEstrellas.tscn").instantiate()
			if michiData[i].type == "Dorado":
				michi = load("res://Michis/michiDorado.tscn").instantiate()
			if michiData[i].type == "Cristal":
				michi = load("res://Michis/michiCristal.tscn").instantiate()
			if michiData[i].type == "Arcoiris":
				michi = load("res://Michis/michiArcoiris.tscn").instantiate()
		#cargar todos los michis de la categoria 5
		elif michiData[i].categoryLevel == 5:
			if michiData[i].type == "Caballero":
				michi = load("res://Michis/michiCaballero.tscn").instantiate()
			if michiData[i].type == "Dragon":
				michi = load("res://Michis/michiDragon.tscn").instantiate()
			if michiData[i].type == "Princesa":
				michi = load("res://Michis/michiPrincesa.tscn").instantiate()
			if michiData[i].type == "Slime":
				michi = load("res://Michis/michiSlime.tscn").instantiate()
			if michiData[i].type == "Unicornio":
				michi = load("res://Michis/michiUnicornio.tscn").instantiate()
		#cargar todos los michis de la categoria 6
		elif michiData[i].categoryLevel == 6:
			if michiData[i].type == "Agua":
				michi = load("res://Michis/michiAgua.tscn").instantiate()
			if michiData[i].type == "Aire":
				michi = load("res://Michis/michiAire.tscn").instantiate()
			if michiData[i].type == "Avatar":
				michi = load("res://Michis/michiAvatar.tscn").instantiate()
			if michiData[i].type == "Fuego":
				michi = load("res://Michis/michiFuego.tscn").instantiate()
			if michiData[i].type == "Tierra":
				michi = load("res://Michis/michiTierra.tscn").instantiate()
		#cargar todos los michis de la categoria 7
		elif michiData[i].categoryLevel == 7:
			if michiData[i].type == "Chino":
				michi = load("res://Michis/michiChino.tscn").instantiate()
			if michiData[i].type == "Halloween":
				michi = load("res://Michis/michiHalloween.tscn").instantiate()
			if michiData[i].type == "Navidad":
				michi = load("res://Michis/michiNavidad.tscn").instantiate()
			if michiData[i].type == "Pascua":
				michi = load("res://Michis/michiPascua.tscn").instantiate()
			if michiData[i].type == "StPatrick":
				michi = load("res://Michis/michiStPatrick.tscn").instantiate()
		#cargar todos los michis de la categoria 8
		elif michiData[i].categoryLevel == 8:
			if michiData[i].type == "Alien":
				michi = load("res://Michis/michiAlien.tscn").instantiate()
			if michiData[i].type == "Angel":
				michi = load("res://Michis/michiAngel.tscn").instantiate()
			if michiData[i].type == "Cyborg":
				michi = load("res://Michis/michiCyborg.tscn").instantiate()
			if michiData[i].type == "Diablo":
				michi = load("res://Michis/michiDiablo.tscn").instantiate()
			if michiData[i].type == "Zombie":
				michi = load("res://Michis/michiZombie.tscn").instantiate()
		#cargar todos los michis de la categoria 9
		elif michiData[i].categoryLevel == 9:
			if michiData[i].type == "Cleopatra":
				michi = load("res://Michis/michiCleopatra.tscn").instantiate()
			if michiData[i].type == "Elvis":
				michi = load("res://Michis/michiElvis.tscn").instantiate()
			if michiData[i].type == "Khalo":
				michi = load("res://Michis/michiKhalo.tscn").instantiate()
			if michiData[i].type == "MJ":
				michi = load("res://Michis/michiMJ.tscn").instantiate()
			if michiData[i].type == "Swifty":
				michi = load("res://Michis/michiSwifty.tscn").instantiate()
		#cargar todos los michis de la categoria 10
		elif michiData[i].categoryLevel == 10:
			if michiData[i].type == "Cthulhu":
				michi = load("res://Michis/michiCthulhu.tscn").instantiate()
			if michiData[i].type == "Dracula":
				michi = load("res://Michis/michiDracula.tscn").instantiate()
			if michiData[i].type == "Frankenstein":
				michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
			if michiData[i].type == "ReyArturo":
				michi = load("res://Michis/michiReyArturo.tscn").instantiate()
			if michiData[i].type == "SherlockHolmes":
				michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
		#cargar todos los michis de la categoria 11
		elif michiData[i].categoryLevel == 11:
			if michiData[i].type == "Espadachin":
				michi = load("res://Michis/michiEspadachin.tscn").instantiate()
			if michiData[i].type == "Hechicero":
				michi = load("res://Michis/michiHechicero.tscn").instantiate()
			if michiData[i].type == "Ninja":
				michi = load("res://Michis/michiNinja.tscn").instantiate()
			if michiData[i].type == "Pirata":
				michi = load("res://Michis/michiPirata.tscn").instantiate()
			if michiData[i].type == "SuperAlien":
				michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
		#cargar todos los michis de la categoria 12
		elif michiData[i].categoryLevel == 12:
			if michiData[i].type == "Aladdin":
				michi = load("res://Michis/michiAladdin.tscn").instantiate()
			if michiData[i].type == "BlancaNieves":
				michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
			if michiData[i].type == "Cenicienta":
				michi = load("res://Michis/michiCenicienta.tscn").instantiate()
			if michiData[i].type == "Cheshire":
				michi = load("res://Michis/michiCheshire.tscn").instantiate()
			if michiData[i].type == "Rapunzel":
				michi = load("res://Michis/michiRapunzel.tscn").instantiate()
		
		
		
				
		michi.global_position = michiData[i].globalPos
		if michi.global_position.y < 211 or michi.global_position.y > 759 or michi.global_position.x < 15 or michi.global_position.x > 465:
			pos_x = rng.randi_range(30,450)
			pos_y = rng.randi_range(260, 734)
			michi.global_position = Vector2(pos_x,pos_y)
		while michi.global_position <= $Caminadora3000Azul.global_position + Vector2(50,50) and michi.global_position >= $Caminadora3000Azul.global_position - Vector2(50,50) or michi.global_position <= $jumper3000.global_position + Vector2(50,50) and michi.global_position >= $jumper3000.global_position - Vector2(50,50):
			pos_x = rng.randi_range(30,450)
			pos_y = rng.randi_range(260, 734)
			michi.global_position = Vector2(pos_x,pos_y)
		michi.name = ("michi"+str(i))
		michi.z_index = 2
		if michiData[i].active == 1 and michiData[i].roomNumber == roomNumber:
			add_child(michi)
		michiInstance.append(michi)
		

	#poner todos los huevos en escena
	for i in range(0, maxHuevoNumber):
		var huevo
		
		if huevoData[i].categoria == 1:
			huevo = load("res://Eggs/Egg1.tscn").instantiate()
		if huevoData[i].categoria == 2:
			huevo = load("res://Eggs/Egg2.tscn").instantiate()
		if huevoData[i].categoria == 3:
			huevo = load("res://Eggs/Egg3.tscn").instantiate()
		if huevoData[i].categoria == 4:
			huevo = load("res://Eggs/Egg4.tscn").instantiate()
		if huevoData[i].categoria == 5:
			huevo = load("res://Eggs/Egg5.tscn").instantiate()
		if huevoData[i].categoria == 6:
			huevo = load("res://Eggs/Egg6.tscn").instantiate()
		if huevoData[i].categoria == 7:
			huevo = load("res://Eggs/Egg7.tscn").instantiate()
		if huevoData[i].categoria == 8:
			huevo = load("res://Eggs/Egg8.tscn").instantiate()
		if huevoData[i].categoria == 9:
			huevo = load("res://Eggs/Egg9.tscn").instantiate()
		if huevoData[i].categoria == 10:
			huevo = load("res://Eggs/Egg10.tscn").instantiate()
		if huevoData[i].categoria == 11:
			huevo = load("res://Eggs/Egg11.tscn").instantiate()
		if huevoData[i].categoria == 12:
			huevo = load("res://Eggs/Egg12.tscn").instantiate()
		
		
		huevo.global_position = huevoData[i].globalPos
		huevo.name = ("huevo"+str(i))
		huevo.z_index = 2
		if huevoData[i].active == 1 and huevoData[i].roomNumber == roomNumber:
			add_child(huevo)
		huevoInstance.append(huevo)
		
		
	#agregar los muebles en pantalla
	for i in range(0, furnitureData.furnitureList.size()):
		furnitureData.furnitureList[i].counterF = 0
		for j in range (0,furnitureData.furnitureList[i].active.size()):
			if furnitureData.furnitureList[i].active[j] == 1:
				if furnitureData.furnitureList[i].roomF[j] == roomNumber:
					print("mandar a poner mueble: ",furnitureData.furnitureList[i].nameF)
					ponerMueble(i,j)
		

	updateMichiStatusBars()

	
func restComfort(numero:int):
	var piPo = (pisCounter + poopCounter) * 4
	michiData[numero].comfort = 100 - piPo
	if michiData[numero].comfort <= 0: michiData[numero].comfort = 0
	
func originRestComfort ():
	var piPo = (pisCounter + poopCounter) * 4
	for i in range(0,maxMichiNumber): 
		michiData[i].comfort = 100 - piPo
		if michiData[i].comfort <= 0: michiData[i].comfort = 0

	
	

	
	
	
func _process(_delta):
	if GlobalVariables.naceMichi == 1:
		naceMichi(GlobalVariables.huevoNumber)
		GlobalVariables.huevoNumber = 101
		GlobalVariables.naceMichi = 0
	if GlobalVariables.michiSelected == true:
		caminadoraLuz.show()
		brincolinLuz.show()
	else: 
		caminadoraLuz.hide()
		brincolinLuz.hide()
	

	if GlobalVariables.michiSelected == true:
		stopJoyStick = true
	if GlobalVariables.huevoSelected == true:
		stopJoyStick = true
	if GlobalVariables.muebleSelected == true:
		stopJoyStick = true
		
	var slide = $JoyStickTest.posVector
	if slide:
		print("joystickPos: ", slide.x)
		if stopJoyStick == false:
			stopJoyStick = true		
			if slide.x > 0.8:
				roomNumber -= 1
				animationControl = false
				if roomNumber <= 0: roomNumber = GlobalVariables.maxRoomNumber
				save(0) 
				$JoyStickTest.visible = false
				slide.x = 0
				stopJoyStick = true
				clearScreenJustHide()
				$Transition/Label.text = "ROOM: "+str(roomNumber)
				$Transition.play("fadeOut")
			elif slide.x < -0.8:
				roomNumber += 1
				animationControl = false
				if roomNumber > 9: roomNumber = 1
				save(0) 
				$JoyStickTest.visible = false
				slide.x = 0
				stopJoyStick = true
				clearScreenJustHide()
				$Transition/Label.text = "ROOM: "+str(roomNumber)
				$Transition.play("fadeOut")

	else:
		stopJoyStick = true
		slide.y = 0
		slide.x = 0
		

#cuando se apieta un michi o un huevo aparecen sus stats mandando a llamar la funcion updateStatus
func _input(_event):
	if Input.is_action_just_pressed("click"):
		$doubleClick.start()
		clickCount += 1
		if clickCount >= 2: doubleClick = true
		otherMichiN = 100
		if not type == -1:	
			if type == 1:
				type = -1
				if controlConfirmPlayInstance == 1 and doubleClick == true:
					var playConfirm = load("res://GUI/ConfirmPlay.tscn").instantiate()
					playConfirm.global_position = Vector2(250,420)
					playConfirm.z_index = huevoInstance[huevoNumber].get_z_index() + 1
					add_child(playConfirm)
					confirmPlayInstance = playConfirm
					GlobalVariables.huevoNumber = huevoNumber
					controlConfirmPlayInstance = 0
			if type == 0:
				type = -1
				if doubleClick == true:
					var changeRoom = load("res://GUI/ChangeMichiRoom.tscn").instantiate()
					changeRoom.global_position = Vector2(0,0)
					changeRoom.z_index = michiInstance[michiNumber].get_z_index() + 1
					GlobalVariables.michiNumber = michiNumber
					var michiPath = ("res://Michis/" + "michi" + michiData[michiNumber].type + ".tscn")
					GlobalVariables.michiPath = michiPath
					add_child(changeRoom)
					confirmChangeRoom = changeRoom
					GlobalVariables.huevoNumber = huevoNumber
		
	if Input.is_action_just_released("click"):			
		if GlobalVariables.michiSelected == false and GlobalVariables.huevoSelected == false and GlobalVariables.muebleSelected == false:
			stopJoyStick = false
					
		
		
func confirmPlay(control : int):
	if control == 1:
		var huevoCat = huevoData[GlobalVariables.huevoNumber].categoria
		GlobalVariables.huevoPath = ("res://Eggs/Egg" + str(huevoCat) + ".tscn")
		save(0)
		get_tree().change_scene_to_file( "res://Scenes/EggJump.tscn")
		confirmPlayInstance.queue_free()
		controlConfirmPlayInstance = 1
	if control == 0:
		controlConfirmPlayInstance = 1
		confirmPlayInstance.queue_free()
		

#emitir una senal al scipt en CanvasLayer para cambiar los stats
func updateStatus(michiN : int, huevoN : int):#type 0 = michi, type 1 = huevo
	if type == 0:
		SignalManager.manageStatusBars.emit(michiData[michiN], huevoData[huevoN], type)
	elif type == 1:
		SignalManager.manageStatusBars.emit(michiData[michiN], huevoData[huevoN], type)
		
	


	
#cargar el archivo y verificar que existe. si no, crear uno nuevo
#typeLocal 0 = michi, type 1 = huevo
# controlMichiData = 0 use the append, = 1 replace the michi data of current number
func loadData(number : int, typeLocal : int, controlMichiData : int): 
	#cargar los michis
	if typeLocal == 0:
		if controlMichiData == 0:
			if ResourceLoader.exists(savePathMichi + saveFileNameMichi + str(number) + ".tres"):
				michiData.append(ResourceLoader.load(savePathMichi + saveFileNameMichi + str(number) + ".tres"))
			else:
				var newMichiData = MichiData.new()
				ResourceSaver.save(newMichiData, (savePathMichi + saveFileNameMichi + str(number) + ".tres" ))
				michiData.append(ResourceLoader.load(savePathMichi + saveFileNameMichi + str(number) + ".tres"))
		elif controlMichiData == 1:
			if ResourceLoader.exists(savePathMichi + saveFileNameMichi + str(number) + ".tres"):
				michiData[number]=(ResourceLoader.load(savePathMichi + saveFileNameMichi + str(number) + ".tres"))

	#cargar los huevos
	elif typeLocal == 1:
		if ResourceLoader.exists(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"):
			huevoData.append(ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"))
		else:
			var newHuevoData = HuevoData.new()
			ResourceSaver.save(newHuevoData, (savePathHuevo + saveFileNameHuevo + str(number) + ".tres" ))
			huevoData.append(ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"))

	#cargar las pis
	elif typeLocal == 2:
		if ResourceLoader.exists(savePathPis + saveFileNamePis + str(number) + ".tres"):
			pisData.append(ResourceLoader.load(savePathPis + saveFileNamePis + str(number) + ".tres"))
		else:
			var newPisData = PisData.new()
			ResourceSaver.save(newPisData, (savePathPis + saveFileNamePis + str(number) + ".tres" ))
			pisData.append(ResourceLoader.load(savePathPis + saveFileNamePis + str(number) + ".tres"))
	
	#cargar las mierdas
	elif typeLocal == 3:
		if ResourceLoader.exists(savePathPoop + saveFileNamePoop + str(number) + ".tres"):
			poopData.append(ResourceLoader.load(savePathPoop + saveFileNamePoop + str(number) + ".tres"))
		else:
			var newPoopData = PoopData.new()
			ResourceSaver.save(newPoopData, (savePathPoop + saveFileNamePoop + str(number) + ".tres" ))
			poopData.append(ResourceLoader.load(savePathPoop + saveFileNamePoop + str(number) + ".tres"))
	elif typeLocal == 4:	
		if ResourceLoader.exists(savePathColorGui + saveFileColorGui + ".tres"):
			getRoomNumber = ResourceLoader.load(savePathColorGui + saveFileColorGui + ".tres")
		else:
			var newRoomNumber = ColorGUI.new()
			ResourceSaver.save(newRoomNumber, (savePathColorGui + saveFileColorGui + ".tres" ))
			getRoomNumber = ResourceLoader.load(savePathColorGui + saveFileColorGui + ".tres")
			
		roomNumber = getRoomNumber.roomNumber
		
	elif typeLocal == 5:
		if ResourceLoader.exists("res://Save/Furniture/furnitureSave.tres"):
			furnitureData = (ResourceLoader.load("res://Save/Furniture/furnitureSave.tres"))
		else:
			var newfurnitureData = furniture.new()
			ResourceSaver.save(newfurnitureData, ("res://Save/Furniture/furnitureSave.tres" ))
			furnitureData = (ResourceLoader.load("res://Save/Furniture/furnitureSave.tres"))
	

#salvar el juego
func salvaMueble():
	#salva mueble
#try 3
	for fur in (furnitureInstance):
		for i in range (0,furnitureData.furnitureList.size()):
			for j in range (0,furnitureData.furnitureList[i].active.size()):
				if fur.name == ("Mueble"+str(i)+"_"+str(j)):
					furnitureData.furnitureList[i].posF[j] = fur.global_position
#try 2
	#for i in range(0, furnitureData.furnitureList.size()):
		#furnitureData.furnitureList[i].counterF = 0
		#for j in range (0,furnitureData.furnitureList[i].active.size()):
			#if furnitureData.furnitureList[i].active[j] == 1:
				#if furnitureData.furnitureList[i].roomF[j] == roomNumber:
					#print("Se salvo mueble: ", furnitureInstance[furnitureData.furnitureList[i].instanceID[j]].name)
					#print("instance position antes: ",furnitureData.furnitureList[i].posF[j])
					#print("instance id: ",furnitureData.furnitureList[i].instanceID[j])
					#if furnitureInstance[furnitureData.furnitureList[i].instanceID[j]].name == ("Mueble"+str(i)+"_"+str(j)):
						#furnitureData.furnitureList[i].posF[j] = furnitureInstance[furnitureData.furnitureList[i].instanceID[j]].global_position
						#print("instance position despues: ",furnitureData.furnitureList[i].posF[j])
						
#try 1
	#for i in range(0, furnitureData.furnitureList.size()):
		#for j in range (0, furnitureData.furnitureList[i].active.size()):
			#if furnitureData.furnitureList[i].active[j] == 1:
				#if furnitureData.furnitureList[i].roomF[j] == roomNumber:
					#print("Instance name: ", furnitureInstance[furnitureData.furnitureList[i].instanceID[j]].name)
					#print("instance position antes: ",furnitureData.furnitureList[i].posF[j])
					#furnitureData.furnitureList[i].posF[j] = furnitureInstance[furnitureData.furnitureList[i].instanceID[j]].global_position
					#print("instance position despues: ",furnitureData.furnitureList[i].posF[j])
	ResourceSaver.save(furnitureData, "res://Save/Furniture/furnitureSave.tres")
func save(michiN : int): #type 0 = michi, type 1 = huevo
	#salva los michis
	for i in range(0, maxMichiNumber):
		if michiData[i].active == 1:
			if not michiN == i:
				michiData[i].globalPos = michiInstance[i].global_position
		ResourceSaver.save(michiData[i], savePathMichi + saveFileNameMichi + str(i) + ".tres")

	#salva los huevos
	for i in range(0, maxHuevoNumber):
		if huevoData[i].active == 1:
			huevoData[i].globalPos = huevoInstance[i].global_position
		ResourceSaver.save(huevoData[i], savePathHuevo + saveFileNameHuevo + str(i) + ".tres")

	#salva la pis
	for i in range(0, maxPisNumber):
		if pisData[i].active == 1:
			pisData[i].globalPos = pisInstance[i].global_position
		ResourceSaver.save(pisData[i], savePathPis + saveFileNamePis + str(i) + ".tres")
	#salva la mierda
	for i in range(0, maxPoopNumber):
		if poopData[i].active == 1:
			poopData[i].globalPos = poopInstance[i].global_position
		ResourceSaver.save(poopData[i], savePathPoop + saveFileNamePoop + str(i) + ".tres")

	getRoomNumber.roomNumber = roomNumber
	ResourceSaver.save(getRoomNumber, savePathColorGui + saveFileColorGui + ".tres")
	
			
	SignalManager.itemsCoinSave.emit()

func _on_texture_button_pressed():
	if btnControl == false:
		btnControl = true
		$Shop.set_visible(true)
		var itemInventario = $inventario.get_node("Item")
		var labelInventario = $inventario.get_node("Label")
		var nextInventario = $inventario.get_node("next")
		var backInventario = $inventario.get_node("back")
		backInventario.hide()
		nextInventario.hide()
		labelInventario.hide()
		itemInventario.hide()
		var parentOfBtn = $inventario
		parentOfBtn.get_node("next").disabled = true
		parentOfBtn.get_node("back").disabled = true
		parentOfBtn.get_node("Settings").disabled = true
		parentOfBtn.get_node("MichiPedia").disabled = true
		parentOfBtn.get_node("Rooms").disabled = true
		$CanvasLayer/Nombre.set_visible(false)
		$CanvasLayer/food.set_visible(false)
		$CanvasLayer/fun.set_visible(false)
		$CanvasLayer/clean.set_visible(false)
		$CanvasLayer/comfort.set_visible(false)
		$CanvasLayer/exercise.set_visible(false)
		SignalManager.michiEggShowHide.emit(0)
	elif btnControl == true:
		btnControl = false
		salvaMueble()
		$Shop.set_visible(false)
		$Shop.get_node("../inventario/Item").set_visible(true)
		$Shop.get_node("../inventario/back").set_visible(true)
		$Shop.get_node("../inventario/next").set_visible(true)
		$Shop.get_node("../inventario/Label").set_visible(true)
		$Shop.get_node("../CanvasLayer/Nombre").set_visible(true)
		$Shop.get_node("../CanvasLayer/food").set_visible(true)
		$Shop.get_node("../CanvasLayer/fun").set_visible(true)
		$Shop.get_node("../CanvasLayer/clean").set_visible(true)
		$Shop.get_node("../CanvasLayer/comfort").set_visible(true)
		$Shop.get_node("../CanvasLayer/exercise").set_visible(true)
		var parentOfBtn = $inventario
		parentOfBtn.get_node("next").disabled = false
		parentOfBtn.get_node("back").disabled = false
		parentOfBtn.get_node("Settings").disabled = false
		parentOfBtn.get_node("MichiPedia").disabled = false
		parentOfBtn.get_node("Rooms").disabled = false
		SignalManager.michiEggShowHide.emit(1)


func _on_change_name_text_changed():
	nombreEditado()


	
	
func editCoinCounter(coins : int):
	$coinCounter.text = str(coins)

#obtener el numero de michi desde el script de michis
func getNumber(number : String, typeLocal : int): #type 0 = michi, type 1 = huevo
	if typeLocal == 0:
		michiNumber = number.to_int()
		$CanvasLayer/Nombre/edit.show()
		$PicMichi.sprite_frames = michiInstance[michiNumber].get_node("AnimatedSprite2D").sprite_frames

		#verificar que el numero de michi no sea mayor que el numero maximo de michi posible
		if maxMichiNumber < michiNumber:
			michiNumber = maxMichiNumber - 1
	if typeLocal == 1:
		huevoNumber = number.to_int()
		$CanvasLayer/Nombre/edit.hide()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxHuevoNumber <= huevoNumber:
			huevoNumber = maxHuevoNumber - 1
	if typeLocal == 2:
		pisNumber = number.to_int()
		$CanvasLayer/Nombre/edit.hide()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxPisNumber <= pisNumber:
			pisNumber = maxPisNumber - 1
		recogerPisyPoop(0)
	if typeLocal == 3:
		poopNumber = number.to_int()
		$CanvasLayer/Nombre/edit.hide()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxPoopNumber <= poopNumber:
			poopNumber = maxPoopNumber - 1
		recogerPisyPoop(1)
	type = typeLocal #actualizar el tipo de objeto selectionado a nivel de script
	
	GlobalVariables.michiNumber = michiNumber
	updateStatus(michiNumber, huevoNumber)
	
	
func merge(michiN : int, otherN: int):
	michiInstance[michiN].visible = false
	michiInstance[otherN].visible = false
	if sceneConfirmControl == 0:
		michiN2 = michiN
		otherMichiN2 = otherN
		var confirm = load("res://GUI/ConfirmMerge.tscn").instantiate()
		confirm.global_position = Vector2(240,427)
		confirm.z_index = michiInstance[michiN].get_z_index() + 1
		add_child(confirm)
		var promMichis = (michiData[michiN].categoryLevel + michiData[otherN].categoryLevel + 1)/2
		SignalManager.michiPair.emit(michiInstance[michiN], michiInstance[otherN], promMichis)
		confirmInstance.append(confirm)
		sceneConfirmControl = 1
		
	
func confirmarMerge(confirmar : int):
	confirmN = confirmN + 1
	if confirmar == 1:
		#michiInstance[michiN2].queue_free()
		michiInstance[otherMichiN2].queue_free()
		agregarMichiyHuevo(michiN2, otherMichiN2, 0)
	if confirmar == 0:
		michiInstance[michiN2].visible = true
		michiInstance[otherMichiN2].visible = true
		
	sceneConfirmControl = 0
	confirmInstance[confirmN].queue_free()
	
func nombreEditado():
	$CanvasLayer/Nombre.text = $CanvasLayer/Nombre/changeName.text
	
	
func _on_edit_pressed():
	$CanvasLayer/Nombre/yes.show()
	$CanvasLayer/Nombre/changeName.show()
	$CanvasLayer/Nombre/no.show()
	
	

func _on_yes_pressed():
	michiData[michiNumber].name = $CanvasLayer/Nombre/changeName.text
	$CanvasLayer/Nombre/yes.hide()
	$CanvasLayer/Nombre/changeName.hide()
	$CanvasLayer/Nombre/no.hide()
	$CanvasLayer/Nombre/changeName.text=""


func _on_no_pressed():
	$CanvasLayer/Nombre/yes.hide()
	$CanvasLayer/Nombre/changeName.hide()
	$CanvasLayer/Nombre/no.hide()
	$CanvasLayer/Nombre/changeName.text=""

func agregarMichiyHuevo(NumeroMichi1 : int, NumeroMichi2 : int, control : int):#if control == 0 se fusionaron michis, control == 1 nace huevo
	randomize()
	var michi
	var huevoIndex = 101

	for i in range(0, maxHuevoNumber):
		if huevoData[i].active == 0:
			huevoIndex = i
			break
			
	if control == 0:
		var promCategorias
		var probNewMichi = rng.randi_range(1,100)
		promCategorias = (michiData[NumeroMichi1].categoryLevel + michiData[NumeroMichi2].categoryLevel)/2
		promCategorias = promCategorias + 1
		
		#hacer nuevo michi categoria 2 
		if promCategorias == 2:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,6)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCalico.tscn").instantiate()
					michiData[NumeroMichi1].type = "Calico"
					michiData[NumeroMichi1].name = "Calico" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiEgipcio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Egipcio"
					michiData[NumeroMichi1].name = "Egipcio" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiManchado.tscn").instantiate()
					michiData[NumeroMichi1].type = "Manchado"
					michiData[NumeroMichi1].name = "Manchado" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPersa.tscn").instantiate()
					michiData[NumeroMichi1].type = "Persa"
					michiData[NumeroMichi1].name = "Persa" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSiames.tscn").instantiate()
					michiData[NumeroMichi1].type = "Siames"
					michiData[NumeroMichi1].name = "Siames" + str(NumeroMichi1)
				if probNewMichiType == 6:
					michi = load("res://Michis/michiTabby.tscn").instantiate()
					michiData[NumeroMichi1].type = "Tabby"
					michiData[NumeroMichi1].name = "Tabby" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
				
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiBlanco.tscn").instantiate()
					michiData[NumeroMichi1].type = "Blanco"
					michiData[NumeroMichi1].name = "Blanco" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiCafe.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cafe"
					michiData[NumeroMichi1].name = "Cafe" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiGris.tscn").instantiate()
					michiData[NumeroMichi1].type = "Gris"
					michiData[NumeroMichi1].name = "Gris" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiNaranja.tscn").instantiate()
					michiData[NumeroMichi1].type = "Naranja"
					michiData[NumeroMichi1].name = "Naranja" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiNegro.tscn").instantiate()
					michiData[NumeroMichi1].type = "Negro"
					michiData[NumeroMichi1].name = "Negro" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiBufanda.tscn").instantiate()
					michiData[NumeroMichi1].type = "Bufanda"
					michiData[NumeroMichi1].name = "Bufanda" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiGirly.tscn").instantiate()
					michiData[NumeroMichi1].type = "Girly"
					michiData[NumeroMichi1].name = "Girly" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiHipster.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hipster"
					michiData[NumeroMichi1].name = "Hipster" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiLentes.tscn").instantiate()
					michiData[NumeroMichi1].type = "Lentes"
					michiData[NumeroMichi1].name = "Lentes" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiMonio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Monio"
					michiData[NumeroMichi1].name = "Monio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
				
		#hacer nuevo michi categoria 3
		if promCategorias == 3:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiBufanda.tscn").instantiate()
					michiData[NumeroMichi1].type = "Bufanda"
					michiData[NumeroMichi1].name = "Bufanda" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiGirly.tscn").instantiate()
					michiData[NumeroMichi1].type = "Girly"
					michiData[NumeroMichi1].name = "Girly" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiHipster.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hipster"
					michiData[NumeroMichi1].name = "Hipster" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiLentes.tscn").instantiate()
					michiData[NumeroMichi1].type = "Lentes"
					michiData[NumeroMichi1].name = "Lentes" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiMonio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Monio"
					michiData[NumeroMichi1].name = "Monio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,6)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCalico.tscn").instantiate()
					michiData[NumeroMichi1].type = "Calico"
					michiData[NumeroMichi1].name = "Calico" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiEgipcio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Egipcio"
					michiData[NumeroMichi1].name = "Egipcio" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiManchado.tscn").instantiate()
					michiData[NumeroMichi1].type = "Manchado"
					michiData[NumeroMichi1].name = "Manchado" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPersa.tscn").instantiate()
					michiData[NumeroMichi1].type = "Persa"
					michiData[NumeroMichi1].name = "Persa" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSiames.tscn").instantiate()
					michiData[NumeroMichi1].type = "Siames"
					michiData[NumeroMichi1].name = "Siames" + str(NumeroMichi1)
				if probNewMichiType == 6:
					michi = load("res://Michis/michiTabby.tscn").instantiate()
					michiData[NumeroMichi1].type = "Tabby"
					michiData[NumeroMichi1].name = "Tabby" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiNeon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Neon"
					michiData[NumeroMichi1].name = "Neon" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiEstrellas.tscn").instantiate()
					michiData[NumeroMichi1].type = "Estrellas"
					michiData[NumeroMichi1].name = "Estrellas" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiDorado.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dorado"
					michiData[NumeroMichi1].name = "Dorado" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCristal.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cristal"
					michiData[NumeroMichi1].name = "Cristal" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiArcoiris.tscn").instantiate()
					michiData[NumeroMichi1].type = "Arcoiris"
					michiData[NumeroMichi1].name = "Arcoiris" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 4
		if promCategorias == 4:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiNeon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Neon"
					michiData[NumeroMichi1].name = "Neon" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiEstrellas.tscn").instantiate()
					michiData[NumeroMichi1].type = "Estrellas"
					michiData[NumeroMichi1].name = "Estrellas" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiDorado.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dorado"
					michiData[NumeroMichi1].name = "Dorado" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCristal.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cristal"
					michiData[NumeroMichi1].name = "Cristal" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiArcoiris.tscn").instantiate()
					michiData[NumeroMichi1].type = "Arcoiris"
					michiData[NumeroMichi1].name = "Arcoiris" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiBufanda.tscn").instantiate()
					michiData[NumeroMichi1].type = "Bufanda"
					michiData[NumeroMichi1].name = "Bufanda" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiGirly.tscn").instantiate()
					michiData[NumeroMichi1].type = "Girly"
					michiData[NumeroMichi1].name = "Girly" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiHipster.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hipster"
					michiData[NumeroMichi1].name = "Hipster" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiLentes.tscn").instantiate()
					michiData[NumeroMichi1].type = "Lentes"
					michiData[NumeroMichi1].name = "Lentes" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiMonio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Monio"
					michiData[NumeroMichi1].name = "Monio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCaballero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Caballero"
					michiData[NumeroMichi1].name = "Caballero" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDragon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dragon"
					michiData[NumeroMichi1].name = "Dragon" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiPrincesa.tscn").instantiate()
					michiData[NumeroMichi1].type = "Princesa"
					michiData[NumeroMichi1].name = "Princesa" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiSlime.tscn").instantiate()
					michiData[NumeroMichi1].type = "Slime"
					michiData[NumeroMichi1].name = "Slime" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiUnicornio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Unicornio"
					michiData[NumeroMichi1].name = "Unicornio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 5
		if promCategorias == 5:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCaballero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Caballero"
					michiData[NumeroMichi1].name = "Caballero" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDragon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dragon"
					michiData[NumeroMichi1].name = "Dragon" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiPrincesa.tscn").instantiate()
					michiData[NumeroMichi1].type = "Princesa"
					michiData[NumeroMichi1].name = "Princesa" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiSlime.tscn").instantiate()
					michiData[NumeroMichi1].type = "Slime"
					michiData[NumeroMichi1].name = "Slime" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiUnicornio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Unicornio"
					michiData[NumeroMichi1].name = "Unicornio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiNeon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Neon"
					michiData[NumeroMichi1].name = "Neon" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiEstrellas.tscn").instantiate()
					michiData[NumeroMichi1].type = "Estrellas"
					michiData[NumeroMichi1].name = "Estrellas" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiDorado.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dorado"
					michiData[NumeroMichi1].name = "Dorado" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCristal.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cristal"
					michiData[NumeroMichi1].name = "Cristal" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiArcoiris.tscn").instantiate()
					michiData[NumeroMichi1].type = "Arcoiris"
					michiData[NumeroMichi1].name = "Arcoiris" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAgua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Agua"
					michiData[NumeroMichi1].name = "Agua" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aire"
					michiData[NumeroMichi1].name = "Aire" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiAvatar.tscn").instantiate()
					michiData[NumeroMichi1].type = "Avatar"
					michiData[NumeroMichi1].name = "Avatar" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiFuego.tscn").instantiate()
					michiData[NumeroMichi1].type = "Fuego"
					michiData[NumeroMichi1].name = "Fuego" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiTierra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Tierra"
					michiData[NumeroMichi1].name = "Tierra" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
				
		#hacer nuevo michi categoria 6
		if promCategorias == 6:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAgua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Agua"
					michiData[NumeroMichi1].name = "Agua" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aire"
					michiData[NumeroMichi1].name = "Aire" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiAvatar.tscn").instantiate()
					michiData[NumeroMichi1].type = "Avatar"
					michiData[NumeroMichi1].name = "Avatar" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiFuego.tscn").instantiate()
					michiData[NumeroMichi1].type = "Fuego"
					michiData[NumeroMichi1].name = "Fuego" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiTierra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Tierra"
					michiData[NumeroMichi1].name = "Tierra" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCaballero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Caballero"
					michiData[NumeroMichi1].name = "Caballero" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDragon.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dragon"
					michiData[NumeroMichi1].name = "Dragon" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiPrincesa.tscn").instantiate()
					michiData[NumeroMichi1].type = "Princesa"
					michiData[NumeroMichi1].name = "Princesa" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiSlime.tscn").instantiate()
					michiData[NumeroMichi1].type = "Slime"
					michiData[NumeroMichi1].name = "Slime" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiUnicornio.tscn").instantiate()
					michiData[NumeroMichi1].type = "Unicornio"
					michiData[NumeroMichi1].name = "Unicornio" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiChino.tscn").instantiate()
					michiData[NumeroMichi1].type = "Chino"
					michiData[NumeroMichi1].name = "Chino" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHalloween.tscn").instantiate()
					michiData[NumeroMichi1].type = "Halloween"
					michiData[NumeroMichi1].name = "Halloween" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNavidad.tscn").instantiate()
					michiData[NumeroMichi1].type = "Navidad"
					michiData[NumeroMichi1].name = "Navidad" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPascua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pascua"
					michiData[NumeroMichi1].name = "Pascua" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiStPatrick.tscn").instantiate()
					michiData[NumeroMichi1].type = "StPatrick"
					michiData[NumeroMichi1].name = "StPatrick" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
				
			#hacer nuevo michi categoria 7
		if promCategorias == 7:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiChino.tscn").instantiate()
					michiData[NumeroMichi1].type = "Chino"
					michiData[NumeroMichi1].name = "Chino" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHalloween.tscn").instantiate()
					michiData[NumeroMichi1].type = "Halloween"
					michiData[NumeroMichi1].name = "Halloween" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNavidad.tscn").instantiate()
					michiData[NumeroMichi1].type = "Navidad"
					michiData[NumeroMichi1].name = "Navidad" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPascua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pascua"
					michiData[NumeroMichi1].name = "Pascua" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiStPatrick.tscn").instantiate()
					michiData[NumeroMichi1].type = "StPatrick"
					michiData[NumeroMichi1].name = "StPatrick" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAgua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Agua"
					michiData[NumeroMichi1].name = "Agua" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aire"
					michiData[NumeroMichi1].name = "Aire" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiAvatar.tscn").instantiate()
					michiData[NumeroMichi1].type = "Avatar"
					michiData[NumeroMichi1].name = "Avatar" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiFuego.tscn").instantiate()
					michiData[NumeroMichi1].type = "Fuego"
					michiData[NumeroMichi1].name = "Fuego" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiTierra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Tierra"
					michiData[NumeroMichi1].name = "Tierra" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "Alien"
					michiData[NumeroMichi1].name = "Alien" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAngel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Angel"
					michiData[NumeroMichi1].name = "Angel" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCyborg.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cyborg"
					michiData[NumeroMichi1].name = "Cyborg" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiDiablo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Diablo"
					michiData[NumeroMichi1].name = "Diablo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiZombie.tscn").instantiate()
					michiData[NumeroMichi1].type = "Zombie"
					michiData[NumeroMichi1].name = "Zombie" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
				
				#hacer nuevo michi categoria 8
		if promCategorias == 8:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "Alien"
					michiData[NumeroMichi1].name = "Alien" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAngel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Angel"
					michiData[NumeroMichi1].name = "Angel" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCyborg.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cyborg"
					michiData[NumeroMichi1].name = "Cyborg" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiDiablo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Diablo"
					michiData[NumeroMichi1].name = "Diablo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiZombie.tscn").instantiate()
					michiData[NumeroMichi1].type = "Zombie"
					michiData[NumeroMichi1].name = "Zombie" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiChino.tscn").instantiate()
					michiData[NumeroMichi1].type = "Chino"
					michiData[NumeroMichi1].name = "Chino" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHalloween.tscn").instantiate()
					michiData[NumeroMichi1].type = "Halloween"
					michiData[NumeroMichi1].name = "Halloween" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNavidad.tscn").instantiate()
					michiData[NumeroMichi1].type = "Navidad"
					michiData[NumeroMichi1].name = "Navidad" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPascua.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pascua"
					michiData[NumeroMichi1].name = "Pascua" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiStPatrick.tscn").instantiate()
					michiData[NumeroMichi1].type = "StPatrick"
					michiData[NumeroMichi1].name = "StPatrick" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCleopatra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cleopatra"
					michiData[NumeroMichi1].name = "Cleopatra" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiElvis.tscn").instantiate()
					michiData[NumeroMichi1].type = "Elvis"
					michiData[NumeroMichi1].name = "Elvis" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiKhalo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Khalo"
					michiData[NumeroMichi1].name = "Khalo" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiMJ.tscn").instantiate()
					michiData[NumeroMichi1].type = "MJ"
					michiData[NumeroMichi1].name = "MJ" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSwifty.tscn").instantiate()
					michiData[NumeroMichi1].type = "Swifty"
					michiData[NumeroMichi1].name = "Swifty" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 9
		if promCategorias == 9:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCleopatra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cleopatra"
					michiData[NumeroMichi1].name = "Cleopatra" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiElvis.tscn").instantiate()
					michiData[NumeroMichi1].type = "Elvis"
					michiData[NumeroMichi1].name = "Elvis" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiKhalo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Khalo"
					michiData[NumeroMichi1].name = "Khalo" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiMJ.tscn").instantiate()
					michiData[NumeroMichi1].type = "MJ"
					michiData[NumeroMichi1].name = "MJ" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSwifty.tscn").instantiate()
					michiData[NumeroMichi1].type = "Swifty"
					michiData[NumeroMichi1].name = "Swifty" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "Alien"
					michiData[NumeroMichi1].name = "Alien" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiAngel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Angel"
					michiData[NumeroMichi1].name = "Angel" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCyborg.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cyborg"
					michiData[NumeroMichi1].name = "Cyborg" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiDiablo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Diablo"
					michiData[NumeroMichi1].name = "Diablo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiZombie.tscn").instantiate()
					michiData[NumeroMichi1].type = "Zombie"
					michiData[NumeroMichi1].name = "Zombie" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCthulhu.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cthulhu"
					michiData[NumeroMichi1].name = "Cthulhu" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDracula.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dracula"
					michiData[NumeroMichi1].name = "Dracula" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
					michiData[NumeroMichi1].type = "Frankenstein"
					michiData[NumeroMichi1].name = "Frankenstein" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiReyArturo.tscn").instantiate()
					michiData[NumeroMichi1].type = "ReyArturo"
					michiData[NumeroMichi1].name = "ReyArturo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
					michiData[NumeroMichi1].type = "SherlockHolmes"
					michiData[NumeroMichi1].name = "SherlockHolmes" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 10
		if promCategorias == 10:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCthulhu.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cthulhu"
					michiData[NumeroMichi1].name = "Cthulhu" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDracula.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dracula"
					michiData[NumeroMichi1].name = "Dracula" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
					michiData[NumeroMichi1].type = "Frankenstein"
					michiData[NumeroMichi1].name = "Frankenstein" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiReyArturo.tscn").instantiate()
					michiData[NumeroMichi1].type = "ReyArturo"
					michiData[NumeroMichi1].name = "ReyArturo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
					michiData[NumeroMichi1].type = "SherlockHolmes"
					michiData[NumeroMichi1].name = "SherlockHolmes" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCleopatra.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cleopatra"
					michiData[NumeroMichi1].name = "Cleopatra" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiElvis.tscn").instantiate()
					michiData[NumeroMichi1].type = "Elvis"
					michiData[NumeroMichi1].name = "Elvis" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiKhalo.tscn").instantiate()
					michiData[NumeroMichi1].type = "Khalo"
					michiData[NumeroMichi1].name = "Khalo" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiMJ.tscn").instantiate()
					michiData[NumeroMichi1].type = "MJ"
					michiData[NumeroMichi1].name = "MJ" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSwifty.tscn").instantiate()
					michiData[NumeroMichi1].type = "Swifty"
					michiData[NumeroMichi1].name = "Swifty" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiEspadachin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Espadachin"
					michiData[NumeroMichi1].name = "Espadachin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHechicero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hechicero"
					michiData[NumeroMichi1].name = "Hechicero" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNinja.tscn").instantiate()
					michiData[NumeroMichi1].type = "Ninja"
					michiData[NumeroMichi1].name = "Ninja" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPirata.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pirata"
					michiData[NumeroMichi1].name = "Pirata" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "SuperAlien"
					michiData[NumeroMichi1].name = "SuperAlien" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 11
		if promCategorias == 11:
			if probNewMichi > 25 and probNewMichi <= 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiEspadachin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Espadachin"
					michiData[NumeroMichi1].name = "Espadachin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHechicero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hechicero"
					michiData[NumeroMichi1].name = "Hechicero" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNinja.tscn").instantiate()
					michiData[NumeroMichi1].type = "Ninja"
					michiData[NumeroMichi1].name = "Ninja" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPirata.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pirata"
					michiData[NumeroMichi1].name = "Pirata" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "SuperAlien"
					michiData[NumeroMichi1].name = "SuperAlien" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCthulhu.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cthulhu"
					michiData[NumeroMichi1].name = "Cthulhu" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDracula.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dracula"
					michiData[NumeroMichi1].name = "Dracula" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
					michiData[NumeroMichi1].type = "Frankenstein"
					michiData[NumeroMichi1].name = "Frankenstein" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiReyArturo.tscn").instantiate()
					michiData[NumeroMichi1].type = "ReyArturo"
					michiData[NumeroMichi1].name = "ReyArturo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
					michiData[NumeroMichi1].type = "SherlockHolmes"
					michiData[NumeroMichi1].name = "SherlockHolmes" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi > 95:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAladdin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aladdin"
					michiData[NumeroMichi1].name = "Aladdin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
					michiData[NumeroMichi1].type = "BlancaNieves"
					michiData[NumeroMichi1].name = "BlancaNieves" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCenicienta.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cenicienta"
					michiData[NumeroMichi1].name = "Cenicienta" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCheshire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cheshire"
					michiData[NumeroMichi1].name = "Cheshire" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiRapunzel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Rapunzel"
					michiData[NumeroMichi1].name = "Rapunzel" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias + 1))
		#hacer nuevo michi categoria 12
		if promCategorias == 12:
			if probNewMichi > 25 and probNewMichi <= 100:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAladdin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aladdin"
					michiData[NumeroMichi1].name = "Aladdin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
					michiData[NumeroMichi1].type = "BlancaNieves"
					michiData[NumeroMichi1].name = "BlancaNieves" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCenicienta.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cenicienta"
					michiData[NumeroMichi1].name = "Cenicienta" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCheshire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cheshire"
					michiData[NumeroMichi1].name = "Cheshire" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiRapunzel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Rapunzel"
					michiData[NumeroMichi1].name = "Rapunzel" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias))
			elif probNewMichi <= 25:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiEspadachin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Espadachin"
					michiData[NumeroMichi1].name = "Espadachin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHechicero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hechicero"
					michiData[NumeroMichi1].name = "Hechicero" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNinja.tscn").instantiate()
					michiData[NumeroMichi1].type = "Ninja"
					michiData[NumeroMichi1].name = "Ninja" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPirata.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pirata"
					michiData[NumeroMichi1].name = "Pirata" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "SuperAlien"
					michiData[NumeroMichi1].name = "SuperAlien" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
		#hacer nuevo michi categoria > 13
		if promCategorias >= 13:
			if probNewMichi > 50:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiAladdin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Aladdin"
					michiData[NumeroMichi1].name = "Aladdin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
					michiData[NumeroMichi1].type = "BlancaNieves"
					michiData[NumeroMichi1].name = "BlancaNieves" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiCenicienta.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cenicienta"
					michiData[NumeroMichi1].name = "Cenicienta" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiCheshire.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cheshire"
					michiData[NumeroMichi1].name = "Cheshire" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiRapunzel.tscn").instantiate()
					michiData[NumeroMichi1].type = "Rapunzel"
					michiData[NumeroMichi1].name = "Rapunzel" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 1))
			elif probNewMichi <= 50 and probNewMichi > 20:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiEspadachin.tscn").instantiate()
					michiData[NumeroMichi1].type = "Espadachin"
					michiData[NumeroMichi1].name = "Espadachin" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiHechicero.tscn").instantiate()
					michiData[NumeroMichi1].type = "Hechicero"
					michiData[NumeroMichi1].name = "Hechicero" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiNinja.tscn").instantiate()
					michiData[NumeroMichi1].type = "Ninja"
					michiData[NumeroMichi1].name = "Ninja" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiPirata.tscn").instantiate()
					michiData[NumeroMichi1].type = "Pirata"
					michiData[NumeroMichi1].name = "Pirata" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
					michiData[NumeroMichi1].type = "SuperAlien"
					michiData[NumeroMichi1].name = "SuperAlien" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 2
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 2))
			elif probNewMichi <= 20:
				var probNewMichiType = rng.randi_range(1,5)
				if probNewMichiType == 1:
					michi = load("res://Michis/michiCthulhu.tscn").instantiate()
					michiData[NumeroMichi1].type = "Cthulhu"
					michiData[NumeroMichi1].name = "Cthulhu" + str(NumeroMichi1)
				if probNewMichiType == 2:
					michi = load("res://Michis/michiDracula.tscn").instantiate()
					michiData[NumeroMichi1].type = "Dracula"
					michiData[NumeroMichi1].name = "Dracula" + str(NumeroMichi1)
				if probNewMichiType == 3:
					michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
					michiData[NumeroMichi1].type = "Frankenstein"
					michiData[NumeroMichi1].name = "Frankenstein" + str(NumeroMichi1)
				if probNewMichiType == 4:
					michi = load("res://Michis/michiReyArturo.tscn").instantiate()
					michiData[NumeroMichi1].type = "ReyArturo"
					michiData[NumeroMichi1].name = "ReyArturo" + str(NumeroMichi1)
				if probNewMichiType == 5:
					michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
					michiData[NumeroMichi1].type = "SherlockHolmes"
					michiData[NumeroMichi1].name = "SherlockHolmes" + str(NumeroMichi1)
				michiData[NumeroMichi1].categoryLevel = promCategorias - 3
				michiData[NumeroMichi1].category = ("categoria"+str(promCategorias - 3))
			
		SignalManager.michiDexUpdate.emit(michiData[NumeroMichi1].type)
		#agrega al michi a la escena
		pos_x = rng.randi_range(30,450)
		pos_y = rng.randi_range(260, 734)
		if michiInstance[NumeroMichi1] and michiInstance[NumeroMichi2]:
			michi.global_position = Vector2(pos_x,pos_y) #verificar que la pos no este ocupada
		else: 
			print("Un michi no existe")
			
		michi.name = "michi"+str(NumeroMichi1)
		michiInstance[NumeroMichi1].name = "tempNameMichi1"
		michi.z_index = 2
		while michi.global_position <= $Caminadora3000Azul.global_position + Vector2(50,50) and michi.global_position >= $Caminadora3000Azul.global_position - Vector2(50,50) or michi.global_position <= $jumper3000.global_position + Vector2(50,50) and michi.global_position >= $jumper3000.global_position - Vector2(50,50):
			pos_x = rng.randi_range(30,450)
			pos_y = rng.randi_range(260, 734)
			michi.global_position = Vector2(pos_x,pos_y)
		add_child(michi)
		michiInstance[NumeroMichi1].queue_free()
		michiInstance[NumeroMichi1] = michi
		michiData[NumeroMichi1].roomNumber = roomNumber
		michiInstance[NumeroMichi2].name = "tempNameMichi2"
		michiInstance[NumeroMichi2].queue_free()
		michiData[NumeroMichi2].active = 0
		
			

		#agregar el huevo
		var probNewEgg = rng.randi_range(1,100)
		if probNewEgg <= 70:
			if huevoIndex < maxHuevoNumber:
				var probNewEggType = rng.randf_range(1.0,100.0)
				var huevo
				var categoriaHuevo
				#1
				if probNewEggType <= 25:
					huevo = load("res://Eggs/Egg1.tscn").instantiate()
					categoriaHuevo = 1
					#2
				elif probNewEggType <= 43 and probNewEggType > 25:
					huevo = load("res://Eggs/Egg2.tscn").instantiate()
					categoriaHuevo = 2
					#3
				elif probNewEggType <= 58 and probNewEggType > 43:
					huevo = load("res://Eggs/Egg3.tscn").instantiate()
					categoriaHuevo = 3
					#4
				elif probNewEggType <= 70 and probNewEggType > 58:
					huevo = load("res://Eggs/Egg4.tscn").instantiate()
					categoriaHuevo = 4
					#5
				elif probNewEggType <= 79 and probNewEggType > 70:
					huevo = load("res://Eggs/Egg5.tscn").instantiate()
					categoriaHuevo = 5
					#6
				elif probNewEggType <= 86 and probNewEggType > 79:
					huevo = load("res://Eggs/Egg6.tscn").instantiate()
					categoriaHuevo = 6
					#7
				elif probNewEggType <= 91 and probNewEggType > 86:
					huevo = load("res://Eggs/Egg7.tscn").instantiate()
					categoriaHuevo = 7
					#8
				elif probNewEggType <= 95 and probNewEggType > 91:
					huevo = load("res://Eggs/Egg8.tscn").instantiate()
					categoriaHuevo = 8
					#9
				elif probNewEggType <= 98 and probNewEggType > 95:
					huevo = load("res://Eggs/Egg9.tscn").instantiate()
					categoriaHuevo = 9
					#10
				elif probNewEggType <= 99 and probNewEggType > 98:
					huevo = load("res://Eggs/Egg10.tscn").instantiate()
					categoriaHuevo = 10
					#11
				elif probNewEggType <= 99.7 and probNewEggType > 99:
					huevo = load("res://Eggs/Egg11.tscn").instantiate()
					categoriaHuevo = 11
					#12
				elif probNewEggType <= 100 and probNewEggType > 99.7:
					huevo = load("res://Eggs/Egg12.tscn").instantiate()
					categoriaHuevo = 12
					
				pos_x = rng.randi_range(30,450)
				pos_y = rng.randi_range(260, 734)
				huevo.global_position = Vector2(pos_x,pos_y)
				huevo.name = "huevo"+str(huevoIndex)
				huevo.z_index = 2
				add_child(huevo)
				huevoInstance[huevoIndex] = huevo
				huevoData[huevoIndex].active = 1
				huevoData[huevoIndex].taps = 5
				huevoData[huevoIndex].roomNumber = roomNumber
				huevoData[huevoIndex].categoria = categoriaHuevo
		
		save(0)
			

#Funcion cuando un huevo llego a 0 taps para hacer nacer un nuevo michi
func naceMichi(huevoN : int):
	
	var michiIndex = 101
	var michi
	var probNewMichiType = GlobalVariables.probNewMichiType
	var michiCategory = GlobalVariables.michiCategory
	
	for i in range(0, maxMichiNumber):
		if michiData[i].active == 0:
			michiIndex = i
			break
		
	
	if michiCategory == 1:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiBlanco.tscn").instantiate()
			michiData[michiIndex].type = "Blanco"
			michiData[michiIndex].name = "Blanco" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiCafe.tscn").instantiate()
			michiData[michiIndex].type = "Cafe"
			michiData[michiIndex].name = "Cafe" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiGris.tscn").instantiate()
			michiData[michiIndex].type = "Gris"
			michiData[michiIndex].name = "Gris" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiNaranja.tscn").instantiate()
			michiData[michiIndex].type = "Naranja"
			michiData[michiIndex].name = "Naranja" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiNegro.tscn").instantiate()
			michiData[michiIndex].type = "Negro"
			michiData[michiIndex].name = "Negro" + str(michiIndex)
			
	if michiCategory == 2:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCalico.tscn").instantiate()
			michiData[michiIndex].type = "Calico"
			michiData[michiIndex].name = "Calico" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiEgipcio.tscn").instantiate()
			michiData[michiIndex].type = "Egipcio"
			michiData[michiIndex].name = "Egipcio" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiManchado.tscn").instantiate()
			michiData[michiIndex].type = "Manchado"
			michiData[michiIndex].name = "Manchado" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPersa.tscn").instantiate()
			michiData[michiIndex].type = "Persa"
			michiData[michiIndex].name = "Persa" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSiames.tscn").instantiate()
			michiData[michiIndex].type = "Siames"
			michiData[michiIndex].name = "Siames" + str(michiIndex)
		if probNewMichiType == 6:
			michi = load("res://Michis/michiTabby.tscn").instantiate()
			michiData[michiIndex].type = "Tabby"
			michiData[michiIndex].name = "Tabby" + str(michiIndex)


	if michiCategory == 3:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiBufanda.tscn").instantiate()
			michiData[michiIndex].type = "Bufanda"
			michiData[michiIndex].name = "Bufanda" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiGirly.tscn").instantiate()
			michiData[michiIndex].type = "Girly"
			michiData[michiIndex].name = "Girly" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiHipster.tscn").instantiate()
			michiData[michiIndex].type = "Hipster"
			michiData[michiIndex].name = "Hipster" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiLentes.tscn").instantiate()
			michiData[michiIndex].type = "Lentes"
			michiData[michiIndex].name = "Lentes" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiMonio.tscn").instantiate()
			michiData[michiIndex].type = "Monio"
			michiData[michiIndex].name = "Monio" + str(michiIndex)

	if michiCategory == 4:
		if probNewMichiType == 5:
			michi = load("res://Michis/michiNeon.tscn").instantiate()
			michiData[michiIndex].type = "Neon"
			michiData[michiIndex].name = "Neon" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiEstrellas.tscn").instantiate()
			michiData[michiIndex].type = "Estrellas"
			michiData[michiIndex].name = "Estrellas" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiDorado.tscn").instantiate()
			michiData[michiIndex].type = "Dorado"
			michiData[michiIndex].name = "Dorado" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiCristal.tscn").instantiate()
			michiData[michiIndex].type = "Cristal"
			michiData[michiIndex].name = "Cristal" + str(michiIndex)
		if probNewMichiType == 1:
			michi = load("res://Michis/michiArcoiris.tscn").instantiate()
			michiData[michiIndex].type = "Arcoiris"
			michiData[michiIndex].name = "Arcoiris" + str(michiIndex)

	if michiCategory == 5:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCaballero.tscn").instantiate()
			michiData[michiIndex].type = "Caballero"
			michiData[michiIndex].name = "Caballero" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiDragon.tscn").instantiate()
			michiData[michiIndex].type = "Dragon"
			michiData[michiIndex].name = "Dragon" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiPrincesa.tscn").instantiate()
			michiData[michiIndex].type = "Princesa"
			michiData[michiIndex].name = "Princesa" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiSlime.tscn").instantiate()
			michiData[michiIndex].type = "Slime"
			michiData[michiIndex].name = "Slime" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiUnicornio.tscn").instantiate()
			michiData[michiIndex].type = "Unicornio"
			michiData[michiIndex].name = "Unicornio" + str(michiIndex)



	if michiCategory == 6:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAgua.tscn").instantiate()
			michiData[michiIndex].type = "Agua"
			michiData[michiIndex].name = "Agua" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiAire.tscn").instantiate()
			michiData[michiIndex].type = "Aire"
			michiData[michiIndex].name = "Aire" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiAvatar.tscn").instantiate()
			michiData[michiIndex].type = "Avatar"
			michiData[michiIndex].name = "Avatar" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiFuego.tscn").instantiate()
			michiData[michiIndex].type = "Fuego"
			michiData[michiIndex].name = "Fuego" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiTierra.tscn").instantiate()
			michiData[michiIndex].type = "Tierra"
			michiData[michiIndex].name = "Tierra" + str(michiIndex)

	if michiCategory == 7:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiChino.tscn").instantiate()
			michiData[michiIndex].type = "Chino"
			michiData[michiIndex].name = "Chino" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiHalloween.tscn").instantiate()
			michiData[michiIndex].type = "Halloween"
			michiData[michiIndex].name = "Halloween" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiNavidad.tscn").instantiate()
			michiData[michiIndex].type = "Navidad"
			michiData[michiIndex].name = "Navidad" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPascua.tscn").instantiate()
			michiData[michiIndex].type = "Pascua"
			michiData[michiIndex].name = "Pascua" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiStPatrick.tscn").instantiate()
			michiData[michiIndex].type = "StPatrick"
			michiData[michiIndex].name = "StPatrick" + str(michiIndex)


	if michiCategory == 8:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAlien.tscn").instantiate()
			michiData[michiIndex].type = "Alien"
			michiData[michiIndex].name = "Alien" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiAngel.tscn").instantiate()
			michiData[michiIndex].type = "Angel"
			michiData[michiIndex].name = "Angel" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiCyborg.tscn").instantiate()
			michiData[michiIndex].type = "Cyborg"
			michiData[michiIndex].name = "Cyborg" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiDiablo.tscn").instantiate()
			michiData[michiIndex].type = "Diablo"
			michiData[michiIndex].name = "Diablo" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiZombie.tscn").instantiate()
			michiData[michiIndex].type = "Zombie"
			michiData[michiIndex].name = "Zombie" + str(michiIndex)
			
	if michiCategory == 9:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCleopatra.tscn").instantiate()
			michiData[michiIndex].type = "Cleopatra"
			michiData[michiIndex].name = "Cleopatra" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiElvis.tscn").instantiate()
			michiData[michiIndex].type = "Elvis"
			michiData[michiIndex].name = "Elvis" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiKhalo.tscn").instantiate()
			michiData[michiIndex].type = "Khalo"
			michiData[michiIndex].name = "Khalo" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiMJ.tscn").instantiate()
			michiData[michiIndex].type = "MJ"
			michiData[michiIndex].name = "MJ" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSwifty.tscn").instantiate()
			michiData[michiIndex].type = "Swifty"
			michiData[michiIndex].name = "Swifty" + str(michiIndex)
	if michiCategory == 10:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiCthulhu.tscn").instantiate()
			michiData[michiIndex].type = "Cthulhu"
			michiData[michiIndex].name = "Cthulhu" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiDracula.tscn").instantiate()
			michiData[michiIndex].type = "Dracula"
			michiData[michiIndex].name = "Dracula" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiFrankenstein.tscn").instantiate()
			michiData[michiIndex].type = "Frankenstein"
			michiData[michiIndex].name = "Frankenstein" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiReyArturo.tscn").instantiate()
			michiData[michiIndex].type = "ReyArturo"
			michiData[michiIndex].name = "ReyArturo" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSherlockHolmes.tscn").instantiate()
			michiData[michiIndex].type = "Swifty"
			michiData[michiIndex].name = "Swifty" + str(michiIndex)
	if michiCategory == 11:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiEspadachin.tscn").instantiate()
			michiData[michiIndex].type = "Espadachin"
			michiData[michiIndex].name = "Espadachin" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiHechicero.tscn").instantiate()
			michiData[michiIndex].type = "Hechicero"
			michiData[michiIndex].name = "Hechicero" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiNinja.tscn").instantiate()
			michiData[michiIndex].type = "Ninja"
			michiData[michiIndex].name = "Ninja" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiPirata.tscn").instantiate()
			michiData[michiIndex].type = "Pirata"
			michiData[michiIndex].name = "Pirata" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiSuperAlien.tscn").instantiate()
			michiData[michiIndex].type = "SuperAlien"
			michiData[michiIndex].name = "SuperAlien" + str(michiIndex)
	if michiCategory == 12:
		if probNewMichiType == 1:
			michi = load("res://Michis/michiAladdin.tscn").instantiate()
			michiData[michiIndex].type = "Aladdin"
			michiData[michiIndex].name = "Aladdin" + str(michiIndex)
		if probNewMichiType == 2:
			michi = load("res://Michis/michiBlancaNieves.tscn").instantiate()
			michiData[michiIndex].type = "BlancaNieves"
			michiData[michiIndex].name = "BlancaNieves" + str(michiIndex)
		if probNewMichiType == 3:
			michi = load("res://Michis/michiCenicienta.tscn").instantiate()
			michiData[michiIndex].type = "Cenicienta"
			michiData[michiIndex].name = "Cenicienta" + str(michiIndex)
		if probNewMichiType == 4:
			michi = load("res://Michis/michiCheshire.tscn").instantiate()
			michiData[michiIndex].type = "Cheshire"
			michiData[michiIndex].name = "Cheshire" + str(michiIndex)
		if probNewMichiType == 5:
			michi = load("res://Michis/michiRapunzel.tscn").instantiate()
			michiData[michiIndex].type = "Rapunzel"
			michiData[michiIndex].name = "Rapunzel" + str(michiIndex)



	michiData[michiIndex].categoryLevel = michiCategory
	michiData[michiIndex].category = ("categoria" + str(michiCategory))
	
	#agrega al michi a la escena
	pos_x = rng.randi_range(30,450)
	pos_y = rng.randi_range(260, 734)
	michi.global_position = Vector2(pos_x,pos_y)
	while michi.global_position <= $Caminadora3000Azul.global_position + Vector2(50,50) and michi.global_position >= $Caminadora3000Azul.global_position - Vector2(50,50) or michi.global_position <= $jumper3000.global_position + Vector2(50,50) and michi.global_position >= $jumper3000.global_position - Vector2(50,50):
		pos_x = rng.randi_range(30,450)
		pos_y = rng.randi_range(260, 734)
		michi.global_position = Vector2(pos_x,pos_y)
		
	michi.name = "michi"+str(michiIndex)
	add_child(michi)
	michiInstance[michiIndex] = michi
	michiData[michiIndex].active = 1
	michiData[michiIndex].roomNumber = roomNumber

	huevoData[huevoN].active = 0
	huevoInstance[huevoN].queue_free()
	GlobalVariables.probNewMichiType = 10
	
	SignalManager.michiDexUpdate.emit(michiData[michiIndex].type)
	save(0)
	
	
	
func michiEggShowHide(control : int):
	if control == 0:
		for i in range(0, maxMichiNumber):
			if michiData[i].active == 1:
				michiInstance[i].modulate.a = 0.05
		for i in range(0, maxHuevoNumber):
			if huevoData[i].active == 1:
				huevoInstance[i].modulate.a = 0.05
			
	else: 
		for i in range(0, maxMichiNumber):
			if michiData[i].active == 1:
				michiInstance[i].modulate.a = 1
		for i in range(0, maxHuevoNumber):
			if huevoData[i].active == 1:
				huevoInstance[i].modulate.a = 1
				


func updateMichiStatus(michiN : int):
	
	
	var huevoD = HuevoData.new()
			
	var index_item = GlobalVariables.indexInventario
	
	if index_item == 0: michiData[michiN].food += 25
	if index_item == 1: michiData[michiN].food += 50
	if index_item == 2: michiData[michiN].food += 75
	if index_item == 3: michiData[michiN].fun += 25
	if index_item == 4: michiData[michiN].fun += 50
	if index_item == 5: michiData[michiN].clean += 25
	if index_item == 6: michiData[michiN].clean += 50
	
	if michiData[michiN].food > 100: michiData[michiN].food = 100
	if michiData[michiN].fun > 100: michiData[michiN].fun = 100
	if michiData[michiN].clean > 100: michiData[michiN].clean = 100
	updateStatus(michiNumber, huevoNumber)
	SignalManager.manageStatusBars.emit(michiData[michiN], huevoD, 0)

	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save(0)
		salvaMueble()


func poopAndPee(michiN : int):
	randomize()
	var probPoopPis = rng.randi_range(1,100)
	var probAdd = rng.randi_range(1,100)
	
	var michiIndex
	for i in range(0, maxMichiNumber):
		if michiData[i].active == 1:
			michiIndex = i
			break
			
	if probPoopPis > 50:	
		var pisIndex
		for i in range(0, maxPisNumber):
			if pisData[i].active == 0:
				pisIndex = i
				break
			else: pisIndex = 101
		if pisIndex < maxPisNumber:
			if probAdd > 15:
				var pis = load("res://Interactives/pis.tscn").instantiate()
				pis.global_position = michiInstance[michiN].global_position
				pis.name = "pis"+str(pisIndex)
				add_child(pis)
				pisCounter +=1
				pisInstance[pisIndex] = pis
				pisInstance[pisIndex].set_z_index(michiInstance[michiIndex].get_z_index() - 1)
				pisData[pisIndex].active = 1
				pisData[pisIndex].roomNumber = roomNumber
	else:
		var poopIndex
		for i in range(0, maxPoopNumber):
			if poopData[i].active == 0:
				poopIndex = i
				break
			else: poopIndex = 101
		if poopIndex < maxPoopNumber:
			if probAdd > 15:
				var poop = load("res://Interactives/PoopRigidBody2D.tscn").instantiate()
				poop.global_position = michiInstance[michiN].global_position
				poop.name = "poop"+str(poopIndex)
				add_child(poop)
				poopCounter += 1
				poopInstance[poopIndex] = poop
				poopInstance[poopIndex].set_z_index(michiInstance[michiIndex].get_z_index() - 1)
				poopData[poopIndex].active = 1
				poopData[poopIndex].roomNumber = roomNumber
	if not michiInstance[michiNumber] == null: restComfort(michiNumber)			
	
func recogerPisyPoop(typeLocal : int): #type = 0 pis, type = 1 poop
	var pos = Vector2(0,0)
	var valor
	if typeLocal == 0:
		pos = pisInstance[pisNumber].global_position
		pisData[pisNumber].active = 0
		pisInstance[pisNumber].name = "tempnamepis"
		pisInstance[pisNumber].queue_free()
		pisCounter -=1
		
	if typeLocal == 1:
		pos = poopInstance[poopNumber].global_position
		poopData[poopNumber].active = 0
		poopInstance[poopNumber].name = "tempnamepoop"
		poopInstance[poopNumber].queue_free()
		poopCounter -= 1
		
	valor = 1
	SignalManager.addCoins.emit(valor)
	crearMoneda(pos)
	restComfort(michiNumber)
	
func michiRunner(body):
	for i in range(0, maxMichiNumber):
		if body.get_name() == ("michi"+str(i)):
			var michiPath = ("res://Michis/" + "michi" + michiData[i].type + ".tscn")
			GlobalVariables.michiPath = michiPath
			save(i)
			get_tree().change_scene_to_file("res://Scenes/michiRun/main.tscn")
			break

func michiJumper(body):
	for i in range(0, maxMichiNumber):
		if body.get_name() == ("michi"+str(i)):
			var michiPath = ("res://Michis/" + "michi" + michiData[i].type + ".tscn")
			GlobalVariables.michiPath = michiPath
			save(i)
			get_tree().change_scene_to_file("res://Scenes/michiJump/jump.tscn")
			break

func crearMoneda(pos : Vector2):
	var timerCoin := Timer.new()
	var timerIndex = 0
	var coinIndex = 0
	
	add_child(timerCoin)
	timerCoinInstance.append(timerCoin)
	timerIndex = timerCoinInstance.size() - 1
	timerCoin.wait_time = 1.0
	timerCoin.one_shot = true
	
	var moneda = load("res://GlobalAssets/coin.tscn").instantiate()
	moneda.global_position = pos
	moneda.name = "moneda"
	add_child(moneda)
	var animacion = moneda.get_node("AnimatedSprite2D")
	animacion.play("show")
	coinInstance.append(moneda)
	coinIndex = coinInstance.size() - 1
	
	if coinIndex == null:
		coinIndex = 0
	if timerIndex == null:
		timerIndex = 0
	
	timerCoin.start()
	timerCoin.timeout.connect(func():deleteCoin(coinIndex, timerIndex))
	
func deleteCoin(coinIndex : int, timerIndex : int):
	var animacion = coinInstance[coinIndex].get_node("AnimatedSprite2D")
	animacion.play("hide")
	animacion.animation_finished.connect(func():freeCoin(coinIndex))
	timerCoinInstance[timerIndex].queue_free()
func freeCoin(index : int):
	coinInstance[index].queue_free()



func clearScreen():
	for cat in michiInstance:
		if is_instance_valid(cat):
			cat.queue_free()
	for eg in huevoInstance:
		if is_instance_valid(eg):
			eg.queue_free()
	for po in poopInstance:
		if is_instance_valid(po):
			po.queue_free()
	for pi in pisInstance:
		if is_instance_valid(pi):
			pi.queue_free()
	for fur in furnitureInstance:
		if is_instance_valid(fur):
			fur.queue_free()

func clearScreenJustHide():
	for cat in michiInstance:
		if is_instance_valid(cat):
			cat.hide()
	for eg in huevoInstance:
		if is_instance_valid(eg):
			eg.hide()
	for po in poopInstance:
		if is_instance_valid(po):
			po.hide()
	for pi in pisInstance:
		if is_instance_valid(pi):
			pi.hide()
			

func clearScreenJustShow():
	for cat in michiInstance:
		if is_instance_valid(cat):
			cat.show()
	for eg in huevoInstance:
		if is_instance_valid(eg):
			eg.show()
	for po in poopInstance:
		if is_instance_valid(po):
			po.show()
	for pi in pisInstance:
		if is_instance_valid(pi):
			pi.show()


func _on_transition_animation_finished(_anim_name):
	if animationControl == false: 
		get_tree().reload_current_scene()


func _on_transition_animation_started(_anim_name):
	if animationControl == true:
		loadData(0, 4 , 0)
		loadData(0,5,0)
		$Transition/Label.text = "ROOM: "+str(roomNumber)
		#for para cargar todos los michis y huevos en arreglos
		for i in range(0, maxMichiNumber):
			loadData(i, 0, 0)
		for i in range(0, maxHuevoNumber):
			loadData(i, 1, 0)
		for i in range(0, maxPisNumber):
			loadData(i, 2 , 0)
		for i in range(0, maxPoopNumber):
			loadData(i, 3 , 0)
			
		if roomNumber == 1:
			$Background1.visible = true
		elif roomNumber == 2:
			$Background2.visible = true
		elif roomNumber == 3:
			$Background3.visible = true
		elif roomNumber == 4:
			$Background4.visible = true
		elif roomNumber == 5:
			$Background5.visible = true
		elif roomNumber == 6:
			$Background6.visible = true
		elif roomNumber == 7:
			$Background7.visible = true
		elif roomNumber == 8:
			$Background8.visible = true
		elif roomNumber == 9:
			$Background9.visible = true
		originRestComfort()
		$JoyStickTest.visible = true

func _on_double_click_timeout():
	clickCount = 0
	doubleClick = false

func updateMichiStatusBars():
	randomize()
	
	var huevoIndex = 101
	for i in range(0, maxHuevoNumber):
		if huevoData[i].active == 1:
			huevoIndex = i
			break
	
	for i in range(0, maxMichiNumber):
		var prob1 = rng.randi_range(1,100)
		if prob1 > 95:
			var prob2 = rng.randi_range(1,3)
			michiData[i].food -= prob2
			prob2 = rng.randi_range(1,3)
			michiData[i].fun -= prob2
			prob2 = rng.randi_range(1,3)
			michiData[i].clean -= prob2
			michiData[i].exercise -= 1
			
			if michiData[i].food < 0: michiData[i].food = 0
			if michiData[i].fun < 0: michiData[i].fun = 0
			if michiData[i].clean < 0: michiData[i].clean = 0
			if michiData[i].exercise < 0: michiData[i].exercise = 0
		
			if 	michiNumber == i and not huevoIndex == 101:
				SignalManager.manageStatusBars.emit(michiData[i], huevoData[huevoIndex], 0)
			
		var promedio = ((michiData[i].food + michiData[i].fun + michiData[i].clean + michiData[i].exercise + michiData[i].comfort)/5)
			#ESTADO DE ANIMO
			
				
		if not michiInstance[i] == null:
			var statusGoodNode = michiInstance[i].get_node("StatusGood")
			if promedio >= 90:
				statusGoodNode.texture = textureHeart
				statusGoodNode.modulate = Color(1,1,1,1)
			else:
				statusGoodNode.texture = textureBall
				if promedio >= 70:
					statusGoodNode.modulate = Color("#38ff26")
				elif promedio >= 40:
					statusGoodNode.modulate = Color("#ffff00")
				else:
					statusGoodNode.modulate = Color("e00000")
					

#controlM 0 click, 1 recurso
func ponerMueble(indexMueble : int, controlM : int):
	var newIndex
	
	var dragMueble = preload("res://Scenes/dragMuebles.gd")
	var character = CharacterBody2D.new()
	

	# Crea un Sprite2D para el mueble.
	var sprite = Sprite2D.new()
	sprite.texture = furnitureData.furnitureList[indexMueble].spriteF
	# Si el mueble tiene más de un frame, ajusta la región del sprite para mostrar solo el primer frame.
	if furnitureData.furnitureList[indexMueble].frameNum > 1:
		var frame_width = sprite.texture.get_width() / furnitureData.furnitureList[indexMueble].frameNum
		sprite.region_enabled = true
		sprite.region_rect = Rect2(0, 0, frame_width, sprite.texture.get_height())
	character.add_child(sprite)
	
	var area1 = Area2D.new()
	area1.name = "areaMueble"
	character.add_child(area1)
	
	var colision1 = CollisionShape2D.new()
	var new_shape = CircleShape2D.new()
	new_shape.radius = 35
	colision1.set_shape(new_shape) 
	colision1.name = "collisionShape"
	area1.add_child(colision1)
	
	
	# Asigna el script clickmueble al character.
	var clickMuebleScript = preload("res://Scenes/Scripts/clickMueble.gd")
	character.set_script(clickMuebleScript)

	# Establece el índice del mueble en el script.
	character.indexMueble = indexMueble
	

	
	for i in range (0,furnitureData.furnitureList[indexMueble].active.size()):
		newIndex = i+1
		if furnitureData.furnitureList[indexMueble].active[i] == 0:
			break
			
				
	var pos = Vector2 (200,500)
	if controlM == -1:
		var nombreIndex2 = furnitureData.furnitureList[indexMueble].active.size()
		character.name = "Mueble" + str(indexMueble) + "_" + str(nombreIndex2)
		print("se cargo mueble:", character.name)
	# Establece la posición global del mueble en la coordenada (200, 500).
		print("Agregar mueble con click")
		if furnitureData.furnitureList[indexMueble].active.is_empty():
			print("primer mueble")
			furnitureData.furnitureList[indexMueble].active.append(1)
			furnitureData.furnitureList[indexMueble].posF.append(pos)
			furnitureData.furnitureList[indexMueble].instanceID.append(furnitureInstanceId)
			furnitureData.furnitureList[indexMueble].roomF.append(roomNumber)
		else:
			print("new index: ",newIndex)
			if newIndex == furnitureData.furnitureList[indexMueble].active.size():
				print("nuevo mueble")
				furnitureData.furnitureList[indexMueble].active.append(1)
				furnitureData.furnitureList[indexMueble].posF.append(pos)
				furnitureData.furnitureList[indexMueble].instanceID.append(furnitureInstanceId)
				furnitureData.furnitureList[indexMueble].roomF.append(roomNumber)
			elif furnitureData.furnitureList[indexMueble].active[newIndex] == 0:
				print("remplazar mueble")
				furnitureData.furnitureList[indexMueble].posF[newIndex] = pos
				furnitureData.furnitureList[indexMueble].instanceID[newIndex] = furnitureInstanceId
			
		character.global_position = pos
		
		
	if not controlM == -1:
		character.name = "Mueble" + str(indexMueble) + "_" + str(controlM)
		print("se cargo mueble:", character.name)
		character.global_position = furnitureData.furnitureList[indexMueble].posF[controlM]
		#print("Counter Mueble: ",counterMueble)
		#if furnitureData.furnitureList[indexMueble].active[counterMueble] == 1:
			#if furnitureData.furnitureList[indexMueble].roomF[counterMueble] == roomNumber:
				#print("mueble puesto de recurso")
				#print("Pos mueble de recurso: ", furnitureData.furnitureList[indexMueble].posF[counterMueble])
				#character.global_position = furnitureData.furnitureList[indexMueble].posF[counterMueble]
		
	
	character.set_script(dragMueble)
	character.z_index = $jumper3000.z_index - 1
	print("zindex: ", character.z_index)
	add_child(character)

	furnitureInstance.append(character)
	furnitureInstanceId += 1
	furnitureData.furnitureList[indexMueble].counterF +=1
	
	
	


