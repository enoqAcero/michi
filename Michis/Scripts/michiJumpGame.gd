extends CharacterBody2D

var horizontalForce = 40
var gravity  = 700
var jumpForce
var prevJumpForce
var bounceFactor
var readyToBounce = false


var maxVelocity = 1000

var area1
var area2


func _ready():
	$StatusGood.visible = false
	$CollisionPolygon2DFlip.disabled = false

func _physics_process(delta):
	if velocity.y > maxVelocity:
		velocity.y = maxVelocity
	else:
		velocity.y += gravity * delta
	
	if Input.is_action_pressed("right"):
		velocity.x += horizontalForce
	if Input.is_action_pressed("left"):
		velocity.x -= horizontalForce
	
	
	
	if is_on_floor() and readyToBounce == false: #and Input.is_action_just_pressed("click"):
		if jumpForce > prevJumpForce:
			jumpForce = prevJumpForce
		velocity.y = -jumpForce
		prevJumpForce = jumpForce
		print("salto normal, fuerza: ", jumpForce)
	if is_on_floor() and readyToBounce == true:
		velocity.y = -jumpForce * bounceFactor
		prevJumpForce = jumpForce
		print("salto trampolin, bounceFactor: ", bounceFactor)
		
	move_and_slide()


#controlar si se salto en el trampolin
func bControl(control : bool):
	if control == true:
		readyToBounce = true
	else:
		readyToBounce = false
	
#modificar el factor de salto en trampolin	
func bFactor(factor : float):
	bounceFactor = factor

#modificar el factor de fuerza de salto
func force(factor : float):
	jumpForce = factor



func _on_change_state_timer_timeout():
	pass
func _on_walking_timer_timeout():
	pass
func _on_area_2d_2_body_entered(_body):
	pass
func _on_poop_and_pee_timer_timeout():
	pass
	
func _on_area_2d_mouse_entered():
	pass
func _on_area_2d_mouse_exited():
	pass




	
