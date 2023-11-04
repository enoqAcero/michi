extends Node2D

var change_scene = load("res://Shop.tscn")
# Called when the node enters the scene tree for the first time.

func _on_open_shop_pressed()-> void:
	get_tree().change_scene_to_packed(change_scene)
	pass # Replace with function body.
