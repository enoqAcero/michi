extends CharacterBody2D

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
		if Input.is_action_pressed("click"):
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
				$StatusGood.offset.x = 0
			if xdir == 1:
				$AnimatedSprite2D.flip_h = true
				$CollisionPolygon2DNormal.disabled = true
				$CollisionPolygon2DFlip.disabled = false
				$StatusGood.offset.x = 30
			velocity.x = speed * xdir
			velocity.y = 0
			
		#Si se mueve vertical decidir que animacion usar
		elif movingVerticalHorizontal == 2:
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


"""
func _on_area_2d_body_entered(body):
	if xdir == 1 and $AnimatedSprite2D.flip_h == false:
		xdir = -1
	elif xdir == -1 and $AnimatedSprite2D.flip_h == true:
		xdir = 1
	
	if ydir == 1:
		ydir = -1
	elif ydir == -1:
		ydir = 1
"""


func _on_area_2d_mouse_entered():
	selected = true
	$AnimatedSprite2D.scale.x = 3
	$AnimatedSprite2D.scale.y = 3
	
	
func _on_area_2d_mouse_exited():
	selected = false
	$AnimatedSprite2D.scale.x = 2
	$AnimatedSprite2D.scale.y = 2
