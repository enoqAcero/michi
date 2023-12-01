extends CharacterBody2D

#variables para drag and drop
var selected = false
var offset 
var originalPosX = 238
var originalPosY = 814

var index = GlobalVariables.indexInventario

var hover = false

var overlappingAreas
var objectName

var maxMichiNumber = GlobalVariables.maxMichiNumber

var giveItemControl = 0

func _process(_delta):
	if selected == false:
		$Area2D/CollisionShape2D.scale.x = 1
		$Area2D/CollisionShape2D.scale.y = 1
		$".".set_collision_layer_value(2, false) # remove from collision layer
		$".".set_collision_mask_value(2, false) # remove from collision mask
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)


func _physics_process(_delta):
	overlappingAreas = $Area2D2.get_overlapping_areas()
	if selected == true:
		for area in overlappingAreas:
			# Get the global positions of the player and the object
			var item_pos = global_position
			var object_pos = area.global_position
			# Check if the player is on top of the object
			if item_pos.y > object_pos.y:
				objectName = area.get_parent()
				objectName = objectName.name
				if Input.is_action_just_released("click"):
					if giveItemControl == 0:
						giveItem()
					
					
	
	if selected == true:
		giveItemControl = 0
		$Area2D/CollisionShape2D.scale.x = 1.3
		$Area2D/CollisionShape2D.scale.y = 1.3
		$".".set_collision_layer_value(2, true) # remove from collision layer
		$".".set_collision_mask_value(2, true) # remove from collision mask
		$".".set_collision_layer_value(1, false)
		$".".set_collision_mask_value(1, false)

		
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
			$Area2D.scale = Vector2(3,3)
		elif Input.is_action_just_released("click"):
			global_position = get_global_mouse_position()
			giveItemControl = 0
			$Area2D.scale = Vector2(1,1)
			selected = false
			GlobalVariables.itemSelected = false
	else:
		$".".position.x=originalPosX
		$".".position.y=originalPosY
		

func _on_area_2d_mouse_entered():
	print("item enter")
	selected = true
	GlobalVariables.itemSelected = true

func _on_area_2d_mouse_exited():
	selected = false
	GlobalVariables.itemSelected = false
	giveItemControl = 0
	
	
func _on_area_2d_2_body_entered(_body):
	pass


func giveItem():
	giveItemControl = 1
	selected = false
	GlobalVariables.michiNumber = 101
	for i in range(0, maxMichiNumber):
		if objectName == ("michi"+str(i)):
			SignalManager.updateItems.emit(1)
			SignalManager.updateMichiStatus.emit(i)
			break
