extends CharacterBody2D

var selected = false

var offset : Vector2
var selected2 = false
var hover = false


func _ready():
	
	$Area2D.mouse_entered.connect(_on_area_2d_mouse_entered)
	$Area2D.mouse_exited.connect(_on_area_2d_mouse_exited)
	$Area2D.set_collision_layer_value(2, false)
	$Area2D.set_collision_layer_value(1, true)
	$".".set_collision_layer_value(1, true)
	
	
func _process(_delta):
		
	if GlobalVariables.muebleHover == true and selected2 == false:
		$Area2D.input_pickable = false
		
	if GlobalVariables.muebleHover == false and selected2 == false:
		$".".set_collision_layer_value(2, false) # remove from collision layer
		$".".set_collision_mask_value(2, false) # remove from collision mask
		$".".set_collision_layer_value(1, true)
		$".".set_collision_mask_value(1, true)
		$Area2D.input_pickable = true
			
			
func _physics_process(_delta):
	if GlobalVariables.lockMuebles == false:
		if GlobalVariables.michiSelected == false:
			if GlobalVariables.huevoSelected == false:
				#if GlobalVariables.muebleSelected == false:
					if selected2 == true:
						$".".set_collision_layer_value(1, false) # remove from collision layer
						$".".set_collision_mask_value(1, false) # remove from collision mask
						$".".set_collision_layer_value(2, true) # remove from collision layer
						$".".set_collision_mask_value(2, true) # remove from collision mask
						
						if Input.is_action_just_pressed("click"):
							$Area2D/CollisionShape2D.scale.x = 5
							$Area2D/CollisionShape2D.scale.y = 5
							GlobalVariables.muebleSelected = true
							offset = get_global_mouse_position() - global_position
						if Input.is_action_pressed("click"):
							global_position = get_global_mouse_position() - offset
						if Input.is_action_just_released("click"):
							global_position = get_global_mouse_position()
							selected2 = false
							GlobalVariables.muebleSelected = false
							$Area2D/CollisionShape2D.scale.x = 1
							$Area2D/CollisionShape2D.scale.y = 1
						
	
	velocity.x = 0
	velocity.y = 0
			
	move_and_slide()
				
	


func _on_area_2d_mouse_entered():
	if GlobalVariables.muebleSelected == false and GlobalVariables.muebleHover == false:
		GlobalVariables.muebleHover = true
		hover = true
		selected2 = true
		
	selected = true

func _on_area_2d_mouse_exited():
	GlobalVariables.muebleSelected = false
	GlobalVariables.muebleHover = false
	selected2 = false
	selected = false



