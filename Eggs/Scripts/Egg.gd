extends CharacterBody2D
var numeroHuevo
var selected = false

var offset : Vector2
var selected2 = false
var hover = false

var originalPos

func _ready():
	numeroHuevo = get_name()
	numeroHuevo = getNumbersFromString(numeroHuevo)
	
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_layer_value(1, true)
	$".".set_collision_layer_value(1, true)
func _process(_delta):
		
	if GlobalVariables.huevoHover == true and selected2 == false:
		$Area2D.input_pickable = false
		
	if GlobalVariables.huevoHover == false and selected2 == false:
		$".".set_collision_layer_value(2, false) # remove from collision layer
		$".".set_collision_mask_value(2, false) # remove from collision mask
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)
		$Area2D.input_pickable = true

			
			
func _physics_process(_delta):
	if GlobalVariables.michiSelected == false:
		if GlobalVariables.muebleHover == false:
			if selected2 == true:
				$Sprite2D.scale = Vector2(2,2)
				$".".set_collision_layer_value(1, false) # remove from collision layer
				$".".set_collision_mask_value(1, false) # remove from collision mask
				$".".set_collision_layer_value(2, true) # remove from collision layer
				$".".set_collision_mask_value(2, true) # remove from collision mask
				$CollisionShape2D.disabled = false
				
				if Input.is_action_just_pressed("click"):
					$Area2D/CollisionShape2D.scale.x = 5
					$Area2D/CollisionShape2D.scale.y = 5
					GlobalVariables.huevoSelected = true
					offset = get_global_mouse_position() - global_position
				if Input.is_action_pressed("click"):
					global_position = get_global_mouse_position() - offset
				if Input.is_action_just_released("click"):
					global_position = get_global_mouse_position()
					selected2 = false
					GlobalVariables.huevoSelected = false
					$Area2D/CollisionShape2D.scale.x = 1
					$Area2D/CollisionShape2D.scale.y = 1
					
	
	velocity.x = 0
	velocity.y = 0
			
	move_and_slide()
				
	
	
#obtener solo los numeros de un string
func getNumbersFromString(input_string: String) -> String:
	var result = ""
	for letter in input_string:
		if letter.is_valid_int():
			result += letter
	return result

func _on_area_2d_mouse_entered():
	if GlobalVariables.huevoSelected == false and GlobalVariables.huevoHover == false:
		GlobalVariables.huevoHover = true
		hover = true
		selected2 = true
		originalPos = global_position
		
	selected = true
	SignalManager.huevoNumber.emit(numeroHuevo, 1) #mandar una senial con el numero del huevo que se esta apretando
func _on_area_2d_mouse_exited():
	GlobalVariables.huevoSelected = false
	GlobalVariables.huevoHover = false
	selected2 = false
	selected = false
	SignalManager.huevoNumber.emit(numeroHuevo, -1) #mandar una senial con el numero del huevo que se esta apretando
	$Sprite2D.scale = Vector2(1,1)


