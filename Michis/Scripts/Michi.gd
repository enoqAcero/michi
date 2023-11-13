extends CharacterBody2D

var maxMichiNumber = GlobalVariables.maxMichiNumber
var maxHuevoNumber = GlobalVariables.maxHuevoNumber

var numeroMichi

#Stats del michi
var comida = 100
var diversion = 100
var limpieza = 100
var comodidad = 100
var energia = 100
var promedio = float(comida+diversion+limpieza+comodidad+energia)/5

#Estados del michi
var idle = false
var walkingDown = false
var walkingUp = false
var walkingSide = false
var walking = false

#variable para ver si el michi esta seleccionado con el mouse
var click_duration = 0.0
var selected = false
var offset: Vector2

#movimento del michi
var xdir = 1 #1 = right, -1 = left
var ydir = 1 #1 = down, -1 = up
var  speed = 30
var movingVerticalHorizontal = 1 #1 = horizontal, 2 = vertical

#var para crear numeros al azar y poder controlar el tiempo y direcciones de movimiento
var rng = RandomNumberGenerator.new()

func _ready():
	#Iniciar movimento y randomizar el estado de idle y walking
	idle = true
	randomize()
	#obtener el nombre del nodo michi# y obtener solo su numero
	numeroMichi = get_name()
	numeroMichi = getNumbersFromString(numeroMichi)

	
func _physics_process(_delta):
	#ESTADO DE ANIMO
	if promedio >= 80:
		$StatusGood.modulate = Color("#38ff26")
	elif promedio >= 50:
		$StatusGood.modulate = Color("#ffff00")
	else:
		$StatusGood.modulate = Color("e00000")
	
	
	#DRAG & DROP
	if selected == true:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			print("dese michi: ", get_name())
			SignalManager.michiNumber.emit(numeroMichi, 0) #mandar una senial con el numero del michi que se esta apretando
		if Input.is_action_pressed("click"):
			#print("michi number from michi script: ", numeroMichi)
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global_position = get_global_mouse_position()
		walking = false
		idle = true
		
		
	#MOVIMIENTO
	#al estar en idle, decidir si se ve a mover vertical o horizontal
	if walking == false:
		var x = rng.randi_range(1,6)
		if x >= 3:
			movingVerticalHorizontal = 1 #si se mueve horizontal habilitar cambiar walkingSide a true
			walkingSide = true
		else:
			movingVerticalHorizontal = 2
				
				
	if walking == true:
		#if para moverse horizontal o vertical. si se mueve horizontal, flipear la animacion y el collision
		if movingVerticalHorizontal == 1:
			#iniciar animacion de WalkingSide
			$AnimatedSprite2D.play("WalkingSide")
			if xdir == -1:
				$AnimatedSprite2D.flip_h = false
				$CollisionPolygon2DNormal.disabled = false
				$CollisionPolygon2DFlip.disabled = true
				$StatusGood.position.x = -20
				$StatusGood.position.y = -36
			if xdir == 1:
				$AnimatedSprite2D.flip_h = true
				$CollisionPolygon2DNormal.disabled = true
				$CollisionPolygon2DFlip.disabled = false
				$StatusGood.position.x = 2
				$StatusGood.position.y = -36
			velocity.x = speed * xdir
			velocity.y = 0
			
		#Si se mueve vertical decidir que animacion usar
		elif movingVerticalHorizontal == 2:
			$AnimatedSprite2D.flip_h = false
			$StatusGood.position.x = -17
			$StatusGood.position.y = -36
			if walkingDown == true:
				$AnimatedSprite2D.play("WalkingDown")
			elif walkingUp == true:
				$AnimatedSprite2D.play("WalkingUp")

			velocity.y = speed * ydir
			velocity.x = 0
			
	#Correr  la animacion de Idle y cancelar todo el movimiento
	if idle == true:
		$AnimatedSprite2D.play("Idle")
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

#funcion para cambiar de caminar a idle basado en un timer random
func _on_change_state_timer_timeout():
	var waitTime = 1
	#Condiciones para cambiar de estado de idle a walking
	if walking == true:
		walking = false
		idle = true
		waitTime = rng.randi_range(1,5)
	elif idle == true:
		walking = true
		idle = false
		waitTime = rng.randi_range(1,10)
	$ChangeStateTimer.wait_time = waitTime
	$ChangeStateTimer.start()


#funcion para decidir la direccion random de movimiento basada en un timer random
func _on_walking_timer_timeout():
	var x = rng.randi_range(1,6)
	var y = rng.randi_range(1,6)
	var waitTime = rng.randi_range (1,5)
	
	if x >= 3:
		xdir = 1
	else:
		xdir = -1
		
	if y >= 3:
		ydir = 1
	else:
		ydir = -1
		
	if ydir == 1:
		walkingDown = true
		walkingUp = false
	elif ydir == -1:
		walkingUp = true
		walkingDown = false
		
	$WalkingTimer.wait_time = waitTime
	$WalkingTimer.start()



#Escalar michi y posicionar status cuando el mouse entra al michi 
func _on_area_2d_mouse_entered():
	selected = true
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.scale.x = 3
	$AnimatedSprite2D.scale.y = 3
	$StatusGood.scale.x = 1
	$StatusGood.scale.y = 1
	$StatusGood.position.x = -29
	$StatusGood.position.y = -55
	$Area2D/CollisionShape2D.scale.x = 5
	$Area2D/CollisionShape2D.scale.y = 5
	$CollisionPolygon2DNormal.disabled = true
	$CollisionPolygon2DFlip.disabled = true
	
	
	

#Escalar michi y posicionar status cuando el mouse sale del michi 
func _on_area_2d_mouse_exited():
	selected = false
	$AnimatedSprite2D.scale.x = 2
	$AnimatedSprite2D.scale.y = 2
	$StatusGood.scale.x = 0.6
	$StatusGood.scale.y = 0.6
	$StatusGood.position.x = -17
	$StatusGood.position.y = -36
	$Area2D/CollisionShape2D.scale.x = 1
	$Area2D/CollisionShape2D.scale.y = 1
	$CollisionPolygon2DNormal.disabled = false
	$CollisionPolygon2DFlip.disabled = false
	$CollisionShape2D.disabled = false

#obtener solo los numeros de un string
func getNumbersFromString(input_string: String) -> String:
	var result = ""
	for letter in input_string:
		if letter.is_valid_int():
			result += letter
	return result


func _on_area_2d_2_body_entered(body):
	if selected == true:
		$CollisionShape2D.disabled = true
		for i in range(0, maxMichiNumber):
			if body.get_name() == ("michi"+str(i)):
				print("colliding")
				SignalManager.merge.emit(i) #mandar una senial con el numero del michi que se esta apretando
				break
