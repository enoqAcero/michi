extends Node2D

#variables para guardar datos
var savePath = "res://Save/"
var saveFileName = "MichiSave"
var michiData : Array[MichiData]
var michiNumber = 0
var maxMichiNumber = 1


var tiempo = 0.0


func _ready():
	#for para cargar todos los michis en un arreglo
	for i in range(0, maxMichiNumber+1):
		loadData(i)
		
	SignalManager.fishBought.connect(editCoinCounter)
	SignalManager.michiNumber.connect(getMichiNumber)
	
	
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
func _on_area_michi_1_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		updateMichiStatus()
func _on_area_michi_2_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		updateMichiStatus()
		

#emitir una senal al scipt en CanvasLayer para cambiar los stats del michi
func updateMichiStatus():
	SignalManager.manageStatusBars.emit(michiData[michiNumber])
	#print("numero: ", michiNumber)

	
#cargar el archivo y verificar que existe. si no, crear uno nuevo
func loadData(number : int):
	if ResourceLoader.exists(savePath + saveFileName + str(number) + ".tres"):
		michiData.append(ResourceLoader.load(savePath + saveFileName + str(number) + ".tres"))
	else:
		var newMichiData = MichiData.new()
		ResourceSaver.save(newMichiData, (savePath + saveFileName + str(number) + ".tres" ))
		michiData.append(ResourceLoader.load(savePath + saveFileName + str(number) + ".tres"))
	print("Se cargo el michi: ", number)

	
	
#salvear el juego
func _on_button_pressed():
	ResourceSaver.save(michiData[michiNumber], savePath + saveFileName + str(michiNumber) + ".tres")
	print ("saving...")

func _on_texture_button_pressed():
	$Shop.set_visible(true)
	get_tree().paused =true
	
func editCoinCounter(coins : int):
	$coinCounter.text = str(coins)

#obtener el numero de michi desde el script de michis
func getMichiNumber(number : String):
	michiNumber = number.to_int() - 1
	#print("michi numero: ", michiNumber)
	if maxMichiNumber >= michiNumber:
		maxMichiNumber = michiNumber
		
	updateMichiStatus()
	
		
	
		




