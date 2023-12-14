extends CharacterBody2D

var maxMichiNumber = GlobalVariables.maxMichiNumber
var maxHuevoNumber = GlobalVariables.maxHuevoNumber

var numeroMichi

#Estados del michi
var idle = false
var walkingDown = false
var walkingUp = false
var walkingSide = false
var walking = false

#variable para ver si el michi esta seleccionado con el mouse
var click_duration = 0.0
var selected = false
var selected2 = true
var offset: Vector2

#movimento del michi
var xdir = 1 #1 = right, -1 = left
var ydir = 1 #1 = down, -1 = up
var  speed = 30
var movingVerticalHorizontal = 1 #1 = horizontal, 2 = vertical

#var para crear numeros al azar y poder controlar el tiempo y direcciones de movimiento
var timerControl = 0
var rng = RandomNumberGenerator.new()

var mergeMichiControl = false

var overlappingAreas
var objectName


func _ready():
	#Iniciar movimento y randomizar el estado de idle y walking
	idle = true
	randomize()
	#obtener el nombre del nodo michi# y obtener solo su numero
	numeroMichi = get_name()
	numeroMichi = getNumbersFromString(numeroMichi)
	$Area2D2/CollisionShape2D.scale.x = 0.4
	$Area2D2/CollisionShape2D.scale.y = 0.4
	
	$ClickTimer.wait_time = 0.2
	$ClickTimer.one_shot = true
	$ClickTimer.timeout.connect(clickControl)
	
	$Area2D2.position = Vector2 (-4,-21)
	$Area2D2.scale = Vector2(5,5)
	$Area2D2.set_collision_layer_value(2, false)
	$Area2D2.set_collision_layer_value(1, true)

func _process(_delta):
	if selected == false:
		$Area2D/CollisionShape2D.scale.x = 1
		$Area2D/CollisionShape2D.scale.y = 1
		
	if GlobalVariables.michiHover == true and selected == false:
		$Area2D.input_pickable = false
		
	if GlobalVariables.michiHover == false and selected == false:
		$".".set_collision_layer_value(2, false) # remove from collision layer
		$".".set_collision_mask_value(2, false) # remove from collision mask
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)
		$Area2D.input_pickable = true
		
	
func _physics_process(_delta):
	overlappingAreas = $Area2D2.get_overlapping_areas()
	
	if selected == true:
		for area in overlappingAreas:
			# Get the global positions of the player and the object
			var player_pos = global_position
			var object_pos = area.global_position
			# Check if the player is on top of the object
			if player_pos.y > object_pos.y:
				objectName = area.get_parent()
				objectName = objectName.name
				if Input.is_action_just_released("click"):
					merge()
	
	if timerControl == 0:
		$poopAndPeeTimer.set_wait_time(rng.randi_range(30,60))#(30,60))
		$poopAndPeeTimer.start()
		timerControl = 1 
	
	
	#DRAG & DROP
	if GlobalVariables.itemSelected==false:
		if GlobalVariables.huevoSelected == false:
			if selected == true:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.scale.x = 3
				$AnimatedSprite2D.scale.y = 3
				$StatusGood.scale.x = 1
				$StatusGood.scale.y = 1
				$StatusGood.position.x = -29
				$StatusGood.position.y = -55
				
				$".".set_collision_layer_value(1, false) # remove from collision layer
				$".".set_collision_mask_value(1, false) # remove from collision mask
				$".".set_collision_layer_value(2, true) # remove from collision layer
				$".".set_collision_mask_value(2, true) # remove from collision mask
				
				
				$CollisionPolygon2DNormal.disabled = true
				$CollisionPolygon2DFlip.disabled = true
				$CollisionShape2D.disabled = false
				
				if selected2 == true:
					if Input.is_action_just_pressed("click"):
						offset = get_global_mouse_position() - global_position
						SignalManager.restComfort.emit(numeroMichi.to_int())
						SignalManager.michiNumber.emit(numeroMichi, 0) #mandar una senial con el numero del michi que se esta apretando
						GlobalVariables.michiSelected = true
					if Input.is_action_pressed("click"):
						global_position = get_global_mouse_position() - offset
						$Area2D/CollisionShape2D.scale.x = 5
						$Area2D/CollisionShape2D.scale.y = 5
					if Input.is_action_just_released("click"):
						global_position = get_global_mouse_position()
						selected = false
						GlobalVariables.michiSelected = false
						$ClickTimer.start()
						$Area2D/CollisionShape2D.scale.x = 1
						$Area2D/CollisionShape2D.scale.y = 1
					walking = false
					idle = true
			
	if selected == false and mergeMichiControl == false:
		GlobalVariables.mergeMichi = false
		$ClickTimer.start()

		
	#MOVIMIENTO
	#al estar en idle, decidir si se ve a mover vertical o horizontal
	if walking == false:
		var x = rng.randi_range(1,100)
		if x > 50:
			movingVerticalHorizontal = 1 #si se mueve horizontal habilitar cambiar walkingSide a true
			walkingSide = true
		else:
			movingVerticalHorizontal = 2
				
				
	if walking == true:
		#if para moverse horizontal o vertical. si se mueve horizontal, flipear la animacion y el collision
		if movingVerticalHorizontal == 1:
			#iniciar animacion de WalkingSide
			$AnimatedSprite2D.play("WalkingSide")
			selected = false
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
			selected = false

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
	var x = rng.randi_range(1,100)
	var y = rng.randi_range(1,100)
	var waitTime = rng.randi_range (1,5)
	
	if x > 50:
		xdir = 1
	else:
		xdir = -1
		
	if y > 50:
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
	if GlobalVariables.michiSelected == false and GlobalVariables.michiHover == false:
		selected = true
		GlobalVariables.michiHover = true
		GlobalVariables.mergeMichi = true
		mergeMichiControl = true
		

#Escalar michi y posicionar status cuando el mouse sale del michi 
func _on_area_2d_mouse_exited():
	GlobalVariables.michiHover = false
	GlobalVariables.michiSelected = false
	selected = false
	selected2 = true
	$AnimatedSprite2D.scale.x = 2
	$AnimatedSprite2D.scale.y = 2
	$StatusGood.scale.x = 0.6
	$StatusGood.scale.y = 0.6
	$StatusGood.position.x = -17
	$StatusGood.position.y = -36
	#$Area2D/CollisionShape2D.scale.x = 1
	#$Area2D/CollisionShape2D.scale.y = 1
	$CollisionPolygon2DNormal.disabled = false
	$CollisionPolygon2DFlip.disabled = false
	
	
	



#obtener solo los numeros de un string
func getNumbersFromString(input_string: String) -> String:
	var result = ""
	for letter in input_string:
		if letter.is_valid_int():
			result += letter
	return result


func _on_area_2d_2_body_entered(_body):
	pass

func _on_poop_and_pee_timer_timeout():
	SignalManager.poopAndPee.emit(numeroMichi.to_int())
	timerControl = 0

func clickControl():
	mergeMichiControl = false
	
	
func merge():
	print("MERGE")
	for i in range(0, maxMichiNumber):
		if objectName == ("michi"+str(i)):
			selected2 = false
			SignalManager.merge.emit(numeroMichi.to_int(), i) #mandar una senial con el numero del michi que se esta apretando
			break
