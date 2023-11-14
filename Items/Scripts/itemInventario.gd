extends CharacterBody2D

#variables para drag and drop
var selected = false
var offset 
var originalPosX = 58
var originalPosY = 835

var index = GlobalVariables.indexInventario


func _physics_process(_delta):
	$Area2D/CollisionShape2D.disabled = false
	if selected == true:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global_position = get_global_mouse_position()
	else:
		$".".position.x=originalPosX
		$".".position.y=originalPosY
		
	if Input.is_action_just_released("click"):
		$Area2D/CollisionShape2D.disabled = true

func _on_area_2d_mouse_entered():
	selected = true

func _on_area_2d_mouse_exited():
	selected = false

func _on_area_2d_2_body_entered(body):
	selected = false
	for i in range(0, GlobalVariables.maxMichiNumber):
		if body.get_name() == ("michi"+str(i)):
			SignalManager.updateItems.emit(1)
			SignalManager.updateMichiStatus.emit(i)
			#SignalManager.save.emit()
			break
