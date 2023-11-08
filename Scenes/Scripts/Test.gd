extends Node2D
#variables para posicionar el huevo
var rng = RandomNumberGenerator.new()
var pos_x
var pos_y

#variables para guardar datos
var savePathMichi = "res://Save/"
var saveFileNameMichi = "MichiSave"
var savePathHuevo = "res://Save/"
var saveFileNameHuevo = "HuevoSave"
var michiData : Array[MichiData]
#crea michis del 0 al maxMichiNumber. si maxMichiNumber = 5 crea en total 6 michis
var michiNumber = 0 
var maxMichiNumber = 4
#crea huevos del 0 al maxHuevoNumber. si maxHuevoNumber = 5 crea en total 6 huevos
var huevoData : Array[HuevoData]
var huevoNumber = 0
var maxHuevoNumber = 1



var tiempo = 0.0


func _ready():
	randomize()
	#poner todos los huevos y michis en escena
	for i in range(0, maxHuevoNumber):
		var huevo = load("res://Eggs/Egg.tscn").instantiate()
		pos_x = rng.randi_range(40,440)
		pos_y = rng.randi_range(100, 754)
		huevo.global_position = Vector2(pos_x,pos_y)
		huevo.name = ("huevo"+str(i))
		add_child(huevo)
	for i in range(0, maxMichiNumber):
		var michi = load("res://Michis/michiNaranja.tscn").instantiate()
		pos_x = rng.randi_range(40,440)
		pos_y = rng.randi_range(100, 754)
		michi.global_position = Vector2(pos_x,pos_y)
		michi.name = ("michi"+str(i))
		add_child(michi)
		
		
	#for para cargar todos los michis en un arreglo
	for i in range(0, maxHuevoNumber):
		loadData(i,1)
	for i in range(0, maxMichiNumber):
		loadData(i,0)
		
	SignalManager.michiNumber.connect(getNumber, 0)
	SignalManager.huevoNumber.connect(getNumber, 1)
	
	
	
	
func _process(_delta):
	
	tiempo = Time.get_ticks_usec() / 1000000
	#print(tiempo)
	
	if tiempo % 5 == 0.0:
		michiData[michiNumber].food = michiData[michiNumber].food - 0.02
		michiData[michiNumber].fun = michiData[michiNumber].fun - 0.02
		michiData[michiNumber].comfort = michiData[michiNumber].comfort - 0.02
		michiData[michiNumber].exercise = michiData[michiNumber].exercise - 0.02
		michiData[michiNumber].clean = michiData[michiNumber].clean - 0.02
		
	
	

#cuando se apieta el michi aparecen sus stats
func _input(event):
	if Input.is_action_pressed("click"):
		updateStatus(michiNumber)
		
		

#emitir una senal al scipt en CanvasLayer para cambiar los stats
func updateStatus(type : int):#type 0 = michi, type 1 = huevo
	if type == 0:
		SignalManager.manageStatusBars.emit(michiData[michiNumber], huevoData[huevoNumber], type)
	elif type == 1:
		SignalManager.manageStatusBars.emit(michiData[michiNumber], huevoData[huevoNumber], type)
	


	
#cargar el archivo y verificar que existe. si no, crear uno nuevo
func loadData(number : int, type : int): #type 0 = michi, type 1 = huevo
	if type == 0:
		if ResourceLoader.exists(savePathMichi + saveFileNameMichi + str(number) + ".tres"):
			michiData.append(ResourceLoader.load(savePathMichi + saveFileNameMichi + str(number) + ".tres"))
		else:
			var newMichiData = MichiData.new()
			ResourceSaver.save(newMichiData, (savePathMichi + saveFileNameMichi + str(number) + ".tres" ))
			michiData.append(ResourceLoader.load(savePathMichi + saveFileNameMichi + str(number) + ".tres"))
		print("Se cargo el michi: ", number)
		#print("comida michi ",  number,":", michiData[number].food)
	elif type == 1:
		if ResourceLoader.exists(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"):
			huevoData.append(ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"))
		else:
			var newHuevoData = HuevoData.new()
			ResourceSaver.save(newHuevoData, (savePathHuevo + saveFileNameHuevo + str(number) + ".tres" ))
			huevoData.append(ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(number) + ".tres"))
		print("Se cargo el huevo: ", number)

	
	
#salvear el juego
func _on_button_pressed(type : int): #type 0 = michi, type 1 = huevo
	if type == 0:
		for i in range(0, maxMichiNumber):
			ResourceSaver.save(michiData[i], savePathMichi + saveFileNameMichi + str(i) + ".tres")
			print ("saving michi: ", i)
	elif type == 1:
		for i in range(0, maxHuevoNumber):
			ResourceSaver.save(huevoData[i], savePathHuevo + saveFileNameHuevo + str(i) + ".tres")
			print ("saving huevo: ", i)

func _on_texture_button_pressed():
	$Shop.set_visible(true)
	get_tree().paused =true
	
func editCoinCounter(coins : int):
	$coinCounter.text = str(coins)

#obtener el numero de michi desde el script de michis
func getNumber(number : String, type : int): #type 0 = michi, type 1 = huevo
	if type == 0:
		michiNumber = number.to_int()
		#print("michi numero: ", michiNumber)
		if maxMichiNumber >= michiNumber:
			maxMichiNumber = michiNumber
		updateStatus(type)
	if type == 1:
		huevoNumber = number.to_int()
		#print("michi numero: ", michiNumber)
		if maxHuevoNumber >= huevoNumber:
			maxHuevoNumber = huevoNumber
		updateStatus(type)
	print("michi number:",michiNumber)
	
