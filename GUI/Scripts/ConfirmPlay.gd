extends Control

func _on_confirm_button_down():
	SignalManager.confirmPlay.emit(1)


func _on_cancel_button_down():
	SignalManager.confirmPlay.emit(0)


