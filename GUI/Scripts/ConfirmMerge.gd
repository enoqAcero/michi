extends Control


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
		
