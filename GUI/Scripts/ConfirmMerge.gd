extends Control



func _ready():
	SignalManager.michiPair.connect(michiPairs)



func michiPairs(michi1P, michi2P):
	$VBoxContainer/michi1Merge.sprite_frames = michi1P.get_node("AnimatedSprite2D").sprite_frames
	$VBoxContainer/michi1Merge2.sprite_frames = michi2P.get_node("AnimatedSprite2D").sprite_frames


	
func _on_confirm_button_down():
	borrarMichi(1)


func _on_cancel_button_down():
	SignalManager.mergeConfirm.emit(0)
	#queue_free()


func borrarMichi(verificar : int):
	if verificar == 1:
		print("borrar michis")
		SignalManager.mergeConfirm.emit(1)
		#queue_free()
		




