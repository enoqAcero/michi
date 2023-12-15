extends CharacterBody2D


func _ready():
	
	$Area2D.mouse_entered.connect(_on_area_2d_mouse_entered)
	$Area2D.mouse_exited.connect(_on_area_2d_mouse_exited)


func _on_area_2d_mouse_entered():
	pass

func _on_area_2d_mouse_exited():
	pass



