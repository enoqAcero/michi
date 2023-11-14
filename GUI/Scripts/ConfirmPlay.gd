extends Control



func _on_confirm_button_down():
	SignalManager.confirmPlay.emit(1)
	print(1)
	


func _on_cancel_button_down():
	SignalManager.confirmPlay.emit(0)
	print(0)


