extends CharacterBody2D
var numeroPis
var selected = false

func _ready():
	numeroPis = get_name()
	numeroPis = getNumbersFromString(numeroPis)
		
func _process(_delta):
	if selected == true:
		if Input.is_action_just_pressed("click"):
			SignalManager.pisNumber.emit(numeroPis, 2)

func _on_area_2d_mouse_entered():
	selected = true
	
func _on_area_2d_mouse_exited():
	selected = false

#obtener solo los numeros de un string
func getNumbersFromString(input_string: String) -> String:
	var result = ""
	for letter in input_string:
		if letter.is_valid_int():
			result += letter
	return result



