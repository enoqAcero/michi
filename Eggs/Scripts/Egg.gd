extends RigidBody2D
var numeroHuevo
var selected = false

func _ready():
	numeroHuevo = get_name()
	numeroHuevo = getNumbersFromString(numeroHuevo)
	
func _process(_delta):
	if selected == true:
		if Input.is_action_just_pressed("click"):
			print("dese huevo: ", get_name())
			SignalManager.huevoNumber.emit(numeroHuevo, 1) #mandar una senial con el numero del huevo que se esta apretando
	
#obtener solo los numeros de un string
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
