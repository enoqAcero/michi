extends CharacterBody2D
var indexMueble
var indexMuebleS
var selected = false
var furnitureResource = preload("res://Save/Furniture/furnitureSave.tres")
var roomNumber = preload ("res://Save/GUI/SaveGUIColor.tres")
var mueble
var labelContadorMuebles 

func _ready():
	labelContadorMuebles = get_parent().get_node("contadorM")
	indexMuebleS = get_name()
	indexMueble = getNumbersFromString(indexMuebleS).to_int()
	mueble = furnitureResource.furnitureList[indexMueble]
	#$Area2D.mouse_entered.connect(_on_area_2d_mouse_entered)
	#$Area2D.mouse_exited.connect(_on_area_2d_mouse_exited)
	# Verifica si el nodo Area2D existe antes de conectar las señales.
# Conecta las señales usando el nombre asignado al nodo Area2D.
	var area2d_node = get_node("AreaMueble" + str(indexMueble))
	if area2d_node:
		area2d_node.mouse_entered.connect(_on_area_2d_mouse_entered)
		area2d_node.mouse_exited.connect(_on_area_2d_mouse_exited)
	else:
		print("Error: Nodo 'AreaMueble" + str(indexMueble) + "' no encontrado.")
		
func _process(_delta):
	if selected == true:
		if Input.is_action_just_pressed("click"):
			if mueble.countF > 0:
				SignalManager.muebleSignal.emit(indexMueble,-1)
			mueble.countF -= 1
			mueble.furnitureInScene[roomNumber.roomNumber] += 1
			if mueble.countF <= 0 :
				mueble.countF = 0
				queue_free()
			labelContadorMuebles.text = str (mueble.countF)  

	
func getNumbersFromString(input_string: String) -> String:
	var result = ""
	for letter in input_string:
		if letter.is_valid_int():
			result += letter
	return result
	
func _on_area_2d_mouse_entered():
	selected = true

func _on_area_2d_mouse_exited():
	selected = false
