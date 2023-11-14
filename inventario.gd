extends Node2D
var coins = 100
var item_index = 0
var Inventory = preload("res://Inventory/inventory.gd")
var inventory_resource
var items = []
var sprite_node
var count_label








# Called when the node enters the scene tree for the first time.
func _ready():
	loadItems()
	sprite_node = get_node("CharacterBody2D/Sprite2D")
	inventory_resource = Inventory.new()  # Crea una nueva instancia de Inventory.
	count_label = $Label
	print(count_label)
	#salvar Items
	SignalManager.itemsCoinSave.connect(itemsCoinSave)
	# Carga los items "fish" y "ball".
	
	
	# Agrega los items a tu inventario.
	inventory_resource.items.append(items[0])
	inventory_resource.items.append(items[1])
	inventory_resource.items.append(items[2])
	inventory_resource.items.append(items[3])
	inventory_resource.items.append(items[4])
	inventory_resource.items.append(items[5])
	inventory_resource.items.append(items[6])
	
	items = inventory_resource.items
	update_item(0)  # Actualiza el sprite y el contador de items.
	
	SignalManager.updateItems.connect(update_item)
	

func itemsCoinSave():
	ResourceSaver.save(items[0], "res://Save/kibble_item.tres")
	ResourceSaver.save(items[1], "res://Save/fish_item.tres") 
	ResourceSaver.save(items[2], "res://Save/tunacan_item.tres") 
	ResourceSaver.save(items[3], "res://Save/ball_item.tres") 
	ResourceSaver.save(items[4], "res://Save/laser_item.tres") 
	ResourceSaver.save(items[5], "res://Save/comb_item.tres") 
	ResourceSaver.save(items[6], "res://Save/brush_item.tres") 
	
func loadItems():
	for i in range (0,7):
		if i == 0: items.append(ResourceLoader.load ("res://Save/kibble_item.tres"))
		if i == 1: items.append(ResourceLoader.load ("res://Save/fish_item.tres"))
		if i == 2: items.append(ResourceLoader.load ("res://Save/tunacan_item.tres"))
		if i == 3: items.append(ResourceLoader.load ("res://Save/ball_item.tres"))
		if i == 4: items.append(ResourceLoader.load ("res://Save/laser_item.tres"))
		if i == 5: items.append(ResourceLoader.load ("res://Save/comb_item.tres"))
		if i == 6: items.append(ResourceLoader.load ("res://Save/brush_item.tres"))
	
	
	
func next_item():
	if item_index < items.size() - 1:
		item_index += 1
	else:
		item_index = 0  # Vuelve al primer item si ya estás en el último.
	update_item(0)
	

func previous_item():
	if item_index > 0:
		item_index -= 1
	else:
		item_index = items.size() - 1  # Vuelve al último item si ya estás en el primero.
	update_item(0)
	
	



func update_item(itemCount : int):
	if itemCount == 1:
		items[item_index].count = items[item_index].count - 1
		count_label.text =str(items[item_index].count)
	else:
		count_label.text =str(items[item_index].count)
		
	sprite_node.texture = items[item_index].texture
	sprite_node.scale = Vector2(0.7,0.7)
	
	GlobalVariables.indexInventario = item_index
	SignalManager.itemsCoinSave.emit()
	loadItems()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_next_pressed():
	next_item()
	pass # Replace with function body.



func _on_back_pressed():
	previous_item()
	pass # Replace with function body.



