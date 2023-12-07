extends Node2D


func _on_global_timer_1_timeout():
	SignalManager.globalTimer1.emit()
