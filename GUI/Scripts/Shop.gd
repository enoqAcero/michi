extends Node2D

var items = load("res://GlobalAssets/Scripts/items.gd").new()


func _ready():
	set_visible(false)

func _on_button_pressed():
	set_visible(false)
	get_tree().paused=false

func _on_buy_fish_pressed():
	var fishCost = items.items[0]["Cost"]
	if items.coins >= fishCost:
		items.coins -= fishCost
		print("Compraste un pez! Te quedan " + str(items.coins) + " monedas.")
		SignalManager.fishBought.emit(items.coins)
	else:
		print("No tienes suficientes monedas para comprar un pez.")
