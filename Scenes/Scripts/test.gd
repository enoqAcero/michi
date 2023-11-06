extends Node2D


	
func _ready():
	var items = load("res://GlobalAssets/Scripts/items.gd").new()
	var coins = items.coins
	$coinCounter.text = str(coins)

	

	

func _on_texture_button_pressed():
	$Shop.set_visible(true)
	get_tree().paused =true
	
