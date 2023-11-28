extends Node2D

var sprite
var collisionBody

var controlTap = 0

var rng = RandomNumberGenerator.new()
var force_x
var globalPos

var savePathHuevo = "res://Save/Huevos/"
var saveFileNameHuevo = "HuevoSave"
var huevoData = ResourceLoader.load(savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")

<<<<<<< HEAD
=======



>>>>>>> origin/master2
func _ready():
	sprite = get_node("RigidBody2D/Sprite2D")
	collisionBody = get_node("RigidBody2D/CollisionShape2D")
	sprite.scale.x = 5
	sprite.scale.y = 5
	collisionBody.scale.x = 5
	collisionBody.scale.y = 5
	$RigidBody2D.freeze = false
	$Label.text = str(huevoData.taps)
	
	

func _input(_event):
	randomize()
	if controlTap == 0:
		if Input.is_action_just_pressed("click"):
			force_x = rng.randi_range(-80,80)
<<<<<<< HEAD
			$RigidBody2D.apply_impulse(Vector2(force_x,-1000))
			globalPos = $RigidBody2D.global_position
			huevoData.taps = huevoData.taps - 1
			$Label.text = str(huevoData.taps)
			if huevoData.taps <= 0:
				GlobalVariables.naceMichi = 1
				save()
				get_tree().change_scene_to_file("res://Scenes/Test.tscn")
			


func _on_button_pressed():
=======
			$RigidBody2D.apply_impulse(Vector2(force_x,-2000))
			globalPos = $RigidBody2D.global_position
			huevoData.taps = huevoData.taps - 1
			$Label.text = str(huevoData.taps)
			if huevoData.taps <= 250:
				var huevoCrack = $RigidBody2D.get_node("Sprite2D")
				huevoCrack.play("crackCat1")
			if huevoData.taps <= 100:
				var huevoCrack = $RigidBody2D.get_node("Sprite2D")
				huevoCrack.play("crackCat1v2")
			if huevoData.taps <= 0:
				var huevoCrack = $RigidBody2D.get_node("Sprite2D")
				huevoCrack.play("crackedCat1")
				huevoData.taps = 0
				$Label.text = str(huevoData.taps)
				get_tree().paused= true
				$ModalMichiHatch.set_visible(true)
				if $ModalMichiHatch.visible:
					$ModalMichiHatch/AnimationPlayer.play("scale_up")
				
				
			





func _on_button_pressed():
	get_tree().paused= false
>>>>>>> origin/master2
	save()
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")
	
func _on_button_mouse_entered():
	controlTap = 1
	
func save():
	ResourceSaver.save(huevoData, savePathHuevo + saveFileNameHuevo + str(GlobalVariables.huevoNumber) + ".tres")



