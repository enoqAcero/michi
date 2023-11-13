extends Node2D
var coins = 100
var item_index = 0
var Inventory = preload("res://Inventory/inventory.gd")
var inventory_resource
var items = []
var sprite_node
var count_label
var kibble_item =preload("res://Inventory/Items/kibble.tres")
var fish_item = preload("res://Inventory/Items/Fish.tres")
var tunacan_item=preload("res://Inventory/Items/tunacan.tres")
var ball_item = preload("res://Inventory/Items/ball.tres")
var laser_item = preload("res://Inventory/Items/laser.tres")
var comb_item = preload("res://Inventory/Items/comb.tres")
var brush_item = preload("res://Inventory/Items/brush.tres")



# Called when the node enters the scene tree for the first time.
func _ready():
	loadItems()
	sprite_node = $PanelContainer/HBoxContainer/Sprite2D
	inventory_resource = Inventory.new()  # Crea una nueva instancia de Inventory.
	count_label = $PanelContainer/HBoxContainer/Sprite2D/ItemCounter
	#salvar Items
	SignalManager.itemsCoinSave.connect(itemsCoinSave)
	# Carga los items "fish" y "ball".
	
	
	# Agrega los items a tu inventario.
	inventory_resource.items.append(kibble_item)
	inventory_resource.items.append(fish_item)
	inventory_resource.items.append(tunacan_item)
	inventory_resource.items.append(ball_item)
	inventory_resource.items.append(laser_item)
	inventory_resource.items.append(comb_item)
	inventory_resource.items.append(brush_item)
	
	items = inventory_resource.items
	update_item()  # Actualiza el sprite y el contador de items.
	pass # Replace with function body.

func itemsCoinSave():
	ResourceSaver.save( kibble_item, "res://Save/kibble_item.tres")
	ResourceSaver.save( fish_item, "res://Save/fish_item.tres") 
	ResourceSaver.save( tunacan_item, "res://Save/tunacan_item.tres") 
	ResourceSaver.save( ball_item, "res://Save/ball_item.tres") 
	ResourceSaver.save( laser_item, "res://Save/laser_item.tres") 
	ResourceSaver.save( comb_item, "res://Save/comb_item.tres") 
	ResourceSaver.save( brush_item, "res://Save/brush_item.tres") 
	
func loadItems():
	items.append(ResourceLoader.load ("res://Save/kibble_item.tres"))
	print(items.append())
	



func next_item():
	if item_index < items.size() - 1:
		item_index += 1
	else:
		item_index = 0  # Vuelve al primer item si ya estás en el último.
	update_item()
	

func previous_item():
	if item_index > 0:
		item_index -= 1
	else:
		item_index = items.size() - 1  # Vuelve al último item si ya estás en el primero.
	update_item()
	loadItems()
	



func update_item():
	var item = items[item_index]
	sprite_node.texture = items[0].texture
	count_label.text =str(items[0].count)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_next_pressed():
	next_item()
	pass # Replace with function body.



func _on_back_pressed():
	previous_item()
	pass # Replace with function body.
