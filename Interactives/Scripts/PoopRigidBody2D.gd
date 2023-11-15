extends RigidBody2D

var numeroPoop
var selected = false

func _ready():
	numeroPoop = get_name()
	numeroPoop = getNumbersFromString(numeroPoop)
		
func _process(_delta):
	if selected == true:
		if Input.is_action_just_pressed("click"):
			SignalManager.poopNumber.emit(numeroPoop, 3)

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



func _on_area_2d_body_entered(body):
	for i in range (0, GlobalVariables.maxMichiNumber):
		if body.get_name() == ("michi"+str(i)) or body.get_name() == ("poop"+str(i)):
			var impulse = Vector2(1000, 0) # the impulse vector
			var point = body.position # the point of application
			#SignalManager.poopColide.emit(i)
			apply_impulse(point, impulse) # apply the impulse to the body
			#print("Impulse")
			break



