extends CharacterBody2D

var gravity = 2000

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.x = 0
	
	move_and_slide()


func _on_area_2d_mouse_entered():
	pass

func _on_area_2d_mouse_exited():
	pass
