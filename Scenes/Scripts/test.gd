extends Node2D

#variables para guardar datos
var savePath = "user://Save/"
var saveFileName = "MichiSave.tres"
var michiData = MichiData.new()


var tiempo = 0.0


func _ready():
	SignalManager.fishBought.connect(editCoinCounter)
	#checar que el directorio y archivo existen
	verifySaveDirectory()
	loadData()
	
func _process(_delta):
	
	tiempo = Time.get_ticks_usec() / 1000000
	print(tiempo)
	
	if tiempo % 5 == 0.0:
		michiData.food = michiData.food - 0.02
		michiData.fun = michiData.fun - 0.02
		michiData.comfort = michiData.comfort - 0.02
		michiData.exercise = michiData.exercise - 0.02
		michiData.clean = michiData.clean - 0.02
		
	
	

#cuando se apieta el michi aparece su nombre en el label
func _on_area_2d_2_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		updateMichiStatus()

func updateMichiStatus():
	SignalManager.manageStatusBars.emit(michiData)

#garantizar que el archivo existe
func verifySaveDirectory():
	if ResourceLoader.exists(savePath + saveFileName):
		pass
	else:
		ResourceSaver.save(michiData, savePath + saveFileName)
	
#cargar el archivo
func loadData():
	michiData = ResourceLoader.load(savePath + saveFileName)
	print("loaded")
	
#salvear el juego
func _on_button_pressed():
	ResourceSaver.save(michiData, savePath + saveFileName)
	print ("saving...")
	

func _on_texture_button_pressed():
	$Shop.set_visible(true)
	get_tree().paused =true
	
func editCoinCounter(coins : int):
	$coinCounter.text = str(coins)
