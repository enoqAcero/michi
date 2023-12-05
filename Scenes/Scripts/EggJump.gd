extends Node2D

var sprite
var collisionBody

var controlTap = 0

var rng = RandomNumberGenerator.new()
var force_x
var force_y = -1000
var globalPos

var huevoScriptPath	= preload("res://Eggs/Scripts/eggJump.gd")
var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var huevoData

var huevoStartPos = Vector2(236,652)
var huevoInstance
#var huevoNode




func _ready():
	huevoData = ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")
	addHuevo()
	$Label.text = str(huevoData.taps)

	
	

func _input(_event):
	randomize()
	if controlTap == 0:
		if Input.is_action_just_pressed("click"):
			force_x = rng.randi_range(-220,200)
			huevoInstance.velocity.x = force_x
			huevoInstance.velocity.y = force_y
			globalPos = huevoInstance.global_position
			huevoData.taps = huevoData.taps - 1
			$Label.text = str(huevoData.taps)
			if huevoData.taps <= 250:
				var huevoCrack = huevoInstance.get_node("Sprite2D")
				huevoCrack.play("crackCat1")
			if huevoData.taps <= 100:
				var huevoCrack = huevoInstance.get_node("Sprite2D")
				huevoCrack.play("crackCat1v2")
			if huevoData.taps <= 0:
				var huevoCrack = huevoInstance.get_node("Sprite2D")
				huevoCrack.play("crackedCat1")
				huevoData.taps = 0
				$Label.text = str(huevoData.taps)
				get_tree().paused= true
				$ModalMichiHatch.set_visible(true)
				if $ModalMichiHatch.visible:
					$ModalMichiHatch/AnimationPlayer.play("scale_up")
			
				
			





func _on_button_pressed():
	get_tree().paused= false
	save()
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")
	
func _on_button_mouse_entered():
	controlTap = 1
	
func save():
	ResourceSaver.save(huevoData, savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")



func addHuevo():
	
	var huevoLoad = ResourceLoader.load(GlobalVariables.huevoPath)
	
	var huevo
	if huevoLoad != null:
		huevo = huevoLoad.instantiate()
	huevo.global_position = huevoStartPos
	huevo.scale = Vector2(5, 5)
	huevo.z_index = 4
	add_child(huevo)
	huevoInstance = huevo
	huevoInstance.name = "huevo"
	
	huevoInstance.set_collision_layer_value(4, true)
	huevoInstance.set_collision_layer_value(1, false)
	huevoInstance.set_collision_mask_value(4, true)
	huevoInstance.set_collision_mask_value(1, false)
	
	huevoInstance.set_script(huevoScriptPath)
	#huevoNode = $".".get_node("huevo")
	

