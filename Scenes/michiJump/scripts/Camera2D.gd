extends Camera2D

var horizontalForce = 20

func _process(delta):
	if Input.is_action_pressed("up"):
		position.y += horizontalForce
	if Input.is_action_pressed("down"):
		position.y -= horizontalForce
