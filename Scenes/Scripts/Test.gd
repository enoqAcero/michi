extends Node2D
#variables para posicionar los michis y huevos
var rng = RandomNumberGenerator.new()
var pos_x
var pos_y

#variables para guardar datos
var savePathMichi = "res://Save/Michis/"
var saveFileNameMichi = "MichiSave"
var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var savePathPis = "res://Save/Pis/"
var saveFileNamePis = "PisSave"
var savePathPoop = "res://Save/Poop/"
var saveFileNamePoop = "PoopSave"
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

var tiempo = 0.0


func _ready():
	randomize()
	#for para cargar todos los michis y huevos en arreglos
	for i in range(0, maxMichiNumber):
		loadData(i, 0, 0)
	for i in range(0, maxHuevoNumber):
		loadData(i, 1, 0)
	for i in range(0, maxPisNumber):
		loadData(i, 2 , 0)
	for i in range(0, maxPoopNumber):
		loadData(i, 3 , 0)
		
	#poner todas la pis
	for i in range(0, maxPisNumber):
		var pis = load("res://Interactives/pis.tscn").instantiate()
		pis.global_position = pisData[i].globalPos
		pis.name = ("pis"+str(i))
		if pisData[i].active == 1:
			add_child(pis)
			print("se agrego pis:", i, " a la escena")	
		pisInstance.append(pis)
		
	#poner todas las mierdas
	for i in range(0, maxPoopNumber):
		var poop = load("res://Interactives/PoopRigidBody2D.tscn").instantiate()
		poop.global_position = poopData[i].globalPos
		poop.name = ("poop"+str(i))
		if poopData[i].active == 1:
			add_child(poop)
			print("se agrego pis:", i, " a la escena")	
		poopInstance.append(poop)
	
	#poner todos los michis en escena	
	for i in range(0, maxMichiNumber): 
		var michi = load("res://Michis/michiNaranja.tscn").instantiate()
		
		#cargar fusiones lvl 1
		if michiData[i].fusionLevel == 1:
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
		#cargar fusiones lvl 2		
		elif michiData[i].fusionLevel == 2:
			pass
		
				
		michi.global_position = michiData[i].globalPos
		michi.name = ("michi"+str(i))
		if michiData[i].active == 1:
			add_child(michi)
			print("se agrego michi:", i, " a la escena")
		michiInstance.append(michi)
		

	#poner todos los huevos en escena
	for i in range(0, maxHuevoNumber):
		var huevo = load("res://Eggs/Egg.tscn").instantiate()
		huevo.global_position = huevoData[i].globalPos
		huevo.name = ("huevo"+str(i))
		if huevoData[i].active == 1:
			add_child(huevo)
			print("se agrego huevo:", i, " a la escena")	
		huevoInstance.append(huevo)
		
	

	
		
		
	
		
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
	
	

	

	
	
func _process(_delta):
	
	tiempo = Time.get_ticks_usec() / 1000000
	#print(tiempo)
	
	if tiempo % 5 == 0.0:
		michiData[michiNumber].food = michiData[michiNumber].food - 0.02
		michiData[michiNumber].fun = michiData[michiNumber].fun - 0.02
		michiData[michiNumber].comfort = michiData[michiNumber].comfort - 0.02
		michiData[michiNumber].exercise = michiData[michiNumber].exercise - 0.02
		michiData[michiNumber].clean = michiData[michiNumber].clean - 0.02
		
	if GlobalVariables.naceMichi == 1:
		naceMichi(GlobalVariables.huevoNumber)
		GlobalVariables.huevoNumber = 101
		GlobalVariables.naceMichi = 0
	

#cuando se apieta un michi o un huevo aparecen sus stats mandando a llamar la funcion updateStatus
func _input(_event):
	if Input.is_action_just_pressed("click"):
		otherMichiN = 100
		if not type == -1:	
			if type == 1:
				if controlConfirmPlayInstance == 1:
					var playConfirm = load("res://GUI/ConfirmPlay.tscn").instantiate()
					playConfirm.global_position = Vector2(147,375.5)
					add_child(playConfirm)
					confirmPlayInstance = playConfirm
					GlobalVariables.huevoNumber = huevoNumber
					controlConfirmPlayInstance = 0
			
					
					
		
		
func confirmPlay(control : int):
	if control == 1:
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


	
	
#salvar el juego
func save(): #type 0 = michi, type 1 = huevo
	#salva los michis
	for i in range(0, maxMichiNumber):
		if michiData[i].active == 1:
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

		
		
	SignalManager.itemsCoinSave.emit()

func _on_texture_button_pressed():
	$Shop.set_visible(true)
	get_tree().paused =true
	$CanvasLayer/Nombre.set_visible(false)
	$CanvasLayer/food.set_visible(false)
	$CanvasLayer/fun.set_visible(false)
	$CanvasLayer/clean.set_visible(false)
	$CanvasLayer/comfort.set_visible(false)
	$CanvasLayer/exercise.set_visible(false)
	SignalManager.michiEggShowHide.emit(0)
		
	
	
	
func editCoinCounter(coins : int):
	$coinCounter.text = str(coins)

#obtener el numero de michi desde el script de michis
func getNumber(number : String, typeLocal : int): #type 0 = michi, type 1 = huevo
	if typeLocal == 0:
		michiNumber = number.to_int()
		#verificar que el numero de michi no sea mayor que el numero maximo de michi posible
		if maxMichiNumber < michiNumber:
			michiNumber = maxMichiNumber - 1
	if typeLocal == 1:
		huevoNumber = number.to_int()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxHuevoNumber <= huevoNumber:
			huevoNumber = maxHuevoNumber - 1
	if typeLocal == 2:
		pisNumber = number.to_int()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxPisNumber <= pisNumber:
			pisNumber = maxPisNumber - 1
		recogerPisyPoop(0)
	if typeLocal == 3:
		poopNumber = number.to_int()
		#verificar que el numero de huevo no sea mayor que el numero maximo de huevo posible
		if maxPoopNumber <= poopNumber:
			poopNumber = maxPoopNumber - 1
		print("poop")
		recogerPisyPoop(1)
	type = typeLocal #actualizar el tipo de objeto selectionado a nivel de script
	
	GlobalVariables.michiNumber = michiNumber
	updateStatus(michiNumber, huevoNumber)
	
	
func merge(michiN : int):
	if otherMichiN == 100:
		otherMichiN = michiN
	
	if not michiN == michiNumber:
		otherMichiN2 = michiNumber
		if not otherMichiN2 == michiN:
			print("merge michi: ",michiN," with michi: ", otherMichiN2)
			michiN2=michiN
			michiInstance[michiN].visible = false
			michiInstance[otherMichiN2].visible = false
		if sceneConfirmControl == 0:
				var confirm = load("res://GUI/ConfirmMerge.tscn").instantiate()
				confirm.global_position = Vector2(147,375.5)
				add_child(confirm)
				confirmInstance.append(confirm)
				sceneConfirmControl = 1
	
func confirmarMerge(confirmar : int):
	confirmN = confirmN + 1
	print ("michiNumber: ",michiN2)
	print ("other michiNumber: ", otherMichiN2)
	if confirmar == 1:
		#michiInstance[michiN2].queue_free()
		michiInstance[otherMichiN2].queue_free()
		agregarMichiyHuevo(michiN2, otherMichiN2, 0)
	if confirmar == 0:
		michiInstance[michiN2].visible = true
		michiInstance[otherMichiN2].visible = true
		
	sceneConfirmControl = 0
	confirmInstance[confirmN].queue_free()
	
	
func agregarMichiyHuevo(NumeroMichi1 : int, NumeroMichi2 : int, control : int):#if control == 0 se fusionaron michis, control == 1 nace huevo
	randomize()
	var michi
	var huevoIndex = 101

	for i in range(0, maxHuevoNumber):
		if huevoData[i].active == 0:
			huevoIndex = i
			break
			
	if control == 0:
		var sumaCategorias
		var probNewMichi = rng.randi_range(1,100)
		sumaCategorias = michiData[NumeroMichi1].categoryLevel + michiData[NumeroMichi2].categoryLevel
		
		#hacer nuevo michi categoria 2 
		if sumaCategorias == 2:
			if probNewMichi > 25 and probNewMichi < 85:
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
				michiData[NumeroMichi1].categoryLevel = sumaCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias))
				
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
				michiData[NumeroMichi1].categoryLevel = sumaCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias - 1))
			elif probNewMichi >= 85:
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
				michiData[NumeroMichi1].categoryLevel = sumaCategorias + 1
				michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias + 1))
				
		#hacer nuevo michi categoria 3
		if sumaCategorias == 3:
			if probNewMichi > 25 and probNewMichi < 85:
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
				michiData[NumeroMichi1].categoryLevel = sumaCategorias
				michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias))
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
				michiData[NumeroMichi1].categoryLevel = sumaCategorias - 1
				michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias - 1))
			elif probNewMichi >= 85:
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
					michiData[NumeroMichi1].categoryLevel = sumaCategorias + 1
					michiData[NumeroMichi1].category = ("categoria"+str(sumaCategorias + 1))
		
		#hacer nuevo michi categoria 4
		if sumaCategorias == 4:
			if probNewMichi > 25 and probNewMichi < 85:
				pass
			elif probNewMichi < 25:
				pass
			elif probNewMichi > 85:
				pass
			
			
		#agrega al michi a la escena
		pos_x = rng.randi_range(30,450)
		pos_y = rng.randi_range(260, 734)
		if michiInstance[NumeroMichi1] and michiInstance[NumeroMichi2]:
			michi.global_position = Vector2(pos_x,pos_y) #verificar que la pos no este ocupada
		else: 
			print("Un michi no existe")
		michi.name = "michi"+str(NumeroMichi1)
		michiInstance[NumeroMichi1].name = "tempNameMichi1"
		add_child(michi)
		michiInstance[NumeroMichi1].queue_free()
		michiInstance[NumeroMichi1] = michi
		michiInstance[NumeroMichi2].name = "tempNameMichi2"
		michiInstance[NumeroMichi2].queue_free()
		michiData[NumeroMichi2].active = 0
			
		#agregar el huevo
		if huevoIndex < maxHuevoNumber:
			var huevo = load("res://Eggs/Egg.tscn").instantiate()
			pos_x = rng.randi_range(30,450)
			pos_y = rng.randi_range(260, 734)
			huevo.global_position = Vector2(pos_x,pos_y)
			huevo.name = "huevo"+str(huevoIndex)
			add_child(huevo)
			huevoInstance[huevoIndex] = huevo
			huevoData[huevoIndex].active = 1
			huevoData[huevoIndex].taps = 5
		
		save()
			

#Funcion cuando un huevo llego a 0 taps para hacer nacer un nuevo michi
func naceMichi(huevoN : int):
	randomize()
	var michiIndex = 101
	var michi
	var probNewMichiType = rng.randi_range(1,5)
	
	for i in range(0, maxMichiNumber):
		if michiData[i].active == 0:
			michiIndex = i
			break
		
	
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
	michiData[michiIndex].categoryLevel = 1
	michiData[michiIndex].category = ("categoria1")
	
	#agrega al michi a la escena
	pos_x = rng.randi_range(30,450)
	pos_y = rng.randi_range(260, 734)
	michi.global_position = Vector2(pos_x,pos_y)
	michi.name = "michi"+str(michiIndex)
	add_child(michi)
	michiInstance[michiIndex] = michi
	michiData[michiIndex].active = 1

	huevoData[huevoN].active = 0
	huevoInstance[huevoN].queue_free()
	
	save()
	
	
	
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
	var index_item = GlobalVariables.indexInventario
	
	print(" Desde update michi status, item index: ",index_item)
	print("MichiN: ",michiN)
	if index_item == 0: michiData[michiN].food += 10
	if index_item == 1: michiData[michiN].food += 20
	if index_item == 2: michiData[michiN].food += 30
	if index_item == 3: michiData[michiN].fun += 10
	if index_item == 4: michiData[michiN].fun += 20
	if index_item == 5: michiData[michiN].clean += 10
	if index_item == 6: michiData[michiN].clean += 20
	
	if michiData[michiN].food > 100: michiData[michiN].food = 100
	if michiData[michiN].fun > 100: michiData[michiN].fun = 100
	if michiData[michiN].clean > 100: michiData[michiN].clean = 100
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save()


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
				pisInstance[pisIndex] = pis
				pisInstance[pisIndex].set_z_index(michiInstance[michiIndex].get_z_index() - 1)
				pisData[pisIndex].active = 1
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
				poopInstance[poopIndex] = poop
				poopInstance[poopIndex].set_z_index(michiInstance[michiIndex].get_z_index() - 1)
				poopData[poopIndex].active = 1
				
	
func recogerPisyPoop(typeLocal : int): #type = 0 pis, type = 1 poop
	if typeLocal == 0:
		pisData[pisNumber].active = 0
		pisInstance[pisNumber].name = "tempnamepis"
		pisInstance[pisNumber].queue_free()
	if typeLocal == 1:
		poopData[poopNumber].active = 0
		poopInstance[poopNumber].name = "tempnamepoop"
		poopInstance[poopNumber].queue_free()

	
