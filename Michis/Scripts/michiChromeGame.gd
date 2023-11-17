extends CharacterBody2D

var gravity  = 5000
var jumpHeight = 2500

func _ready():
	$AnimatedSprite2D.flip_h = true
	$StatusGood.visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("click") and is_on_floor():
		velocity.y -= jumpHeight
		
	velocity.y += gravity * delta
	move_and_slide()
	


func _on_change_state_timer_timeout():
	pass
func _on_walking_timer_timeout():
	pass
func _on_area_2d_2_body_entered(_body):
	pass
func _on_poop_and_pee_timer_timeout():
	pass
