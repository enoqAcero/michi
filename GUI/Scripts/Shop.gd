extends Node2D
var Inventory = preload("res://Inventory/inventory.gd")
var furnitureResource = preload("res://Save/Furniture/furnitureSave.tres")
var moneditas = ResourceLoader.load("res://Save/moneditas.tres")#= preload("res://Inventory/bolsa_monedas.tres")
var label_settings = preload("res://tipoNum.tres")
var buy_texture = preload("res://GUI/Assets/buyN.png")

var maxMichiNumber = GlobalVariables.maxMichiNumber
var monedero_resource
var inventory_resource
var item_index = 0
var items
var count_label
var buy_kibble_button
var buy_fish_button
var buy_tunacan_button
var buy_ball_button
var buy_laser_button
var buy_comb_button
var buy_brush_button
var fish_label
var kibble_label
var tunacan_label
var laser_label
var comb_label
var brush_label
var ball_label
var kibble_price_label
var fish_price_label
var tunacan_price_label
var ball_price_label
var laser_price_label
var comb_price_label
var brush_price_label
var coins_label
var michiCoin
var items_Container
var furnitures_Container
var items_button
var furnitures_button
var bg_furnitures
var bg_items
var muebles : furniture
var NumMueble = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	set_visible(false)
	
	SignalManager.itemsCoinSave.connect(itemsCoinSave)
	SignalManager.addCoins.connect(addCoins)
	# Antes de usar inventory_resource.items, necesitas instanciar inventory_resource.
	inventory_resource = Inventory.new()
	buy_kibble_button = $GridContainer/kibble/buykibble
	buy_fish_button = $GridContainer/fish/buyFish
	buy_tunacan_button = $GridContainer/tunacan/buytunacan
	buy_ball_button = $GridContainer/ball/buyball
	buy_laser_button = $GridContainer/laser/buylaser
	buy_comb_button = $GridContainer/comb/buycomb
	buy_brush_button = $GridContainer/brush/buybrush
	kibble_label = $GridContainer/kibble/kibbleLabelInv
	fish_label = $GridContainer/fish/fishLabelInv
	tunacan_label = $GridContainer/tunacan/tunacanLabelInv
	ball_label = $GridContainer/ball/ballLabelInv
	laser_label = $GridContainer/laser/laserLabelInv
	comb_label = $GridContainer/comb/combLabelInv
	brush_label = $GridContainer/brush/brushLabelInv
	kibble_price_label = $GridContainer/kibble/kibbleLabelCost
	fish_price_label = $GridContainer/fish/fishLabelCost
	tunacan_price_label = $GridContainer/tunacan/tunacanLabelCost
	ball_price_label = $GridContainer/ball/ballLabelCost
	laser_price_label = $GridContainer/laser/laserLabelCost
	comb_price_label = $GridContainer/comb/combLabelCost
	brush_price_label = $GridContainer/brush/brushLabelCost
	coins_label = $coinCounter
	michiCoin = $MichiCoin
	items_Container = $GridContainer
	furnitures_Container = $ScrollContainer
	bg_furnitures = $bgFurnitures
	bg_items = $"Bg-store"
	items_button = $Items
	furnitures_button = $Furnitures
	items_Container.visible = true
	# Obtenemos el nodo ScrollContainer y control
	#var scroll_container = get_node("ScrollContainerNew")
	#var control_node = get_node("ScrollContainerNew/Controlnew")
	var vbox = get_node("ScrollContainerNew/Controlnew/VBoxContainer")
	# Configuramos la separación entre los elementos

	# Recorremos la lista de muebles
	for fuun in furnitureResource.furnitureList:
		var item_hbox = HBoxContainer.new()
		
		# Texturas muebles
		var sprite = TextureRect.new()
		sprite.texture = fuun.spriteF
		#if fuun.frameNum > 1:
			#var frame_width = sprite.texture.get_width() / fuun.frameNum
			#sprite.region_enabled = true
			#sprite.region_rect = Rect2(0, 0, frame_width, sprite.texture.get_height())
		sprite.stretch_mode = TextureRect.STRETCH_KEEP
		item_hbox.add_child(sprite)
		
		var text_vbox = VBoxContainer.new()
		item_hbox.add_child(text_vbox)
		
		# Nombre muebles
		var name_label = Label.new()
		name_label.text = fuun.nameF
		name_label.label_settings = label_settings		
		text_vbox.add_child(name_label)
		
		
		#Precio muebles
		var price_label = Label.new()
		price_label.text = "$%d" % fuun.costF
		price_label.label_settings = label_settings		
		text_vbox.add_child(price_label)
		
		#cantidad de muebles
		var count_labelM = Label.new()
		count_labelM.text = "Cantidad: %d" % fuun.countF
		count_labelM.label_settings = label_settings
		text_vbox.add_child(count_labelM)	
		vbox.add_child(item_hbox)
		
		#botón comprar
		var buy_button = TextureButton.new()
		buy_button.name = "comprar" + str(NumMueble)
		buy_button.texture_normal = buy_texture
		text_vbox.add_child(buy_button)

		# Conectar la señal 'pressed' del botón a la función '_on_comprar_pressed'
		buy_button.pressed.connect(Callable(_buy_button_pressed).bind(count_labelM, NumMueble))
		#vbox.add_child(item_hbox)
		# y pasar 'furniture' y 'count_label' como argumentos.
		#muebles.furnitureList.append(fuun)
		NumMueble += 1

	# Carga los items.
	
	var kibble_item = ResourceLoader.load ("res://Save/kibble_item.tres")
	var fish_item = ResourceLoader.load ("res://Save/fish_item.tres")
	var tunacan_item = ResourceLoader.load ("res://Save/tunacan_item.tres")
	var ball_item = ResourceLoader.load ("res://Save/ball_item.tres")
	var laser_item = ResourceLoader.load ("res://Save/laser_item.tres")
	var comb_item = ResourceLoader.load ("res://Save/comb_item.tres")
	var brush_item = ResourceLoader.load ("res://Save/brush_item.tres")
	#moneditas = ResourceLoader.load ("res://Save/brush_item.tres")
	
	
	#remplazo nombres de labels
	coins_label.text = str(moneditas.coin)
	kibble_price_label.text = str(kibble_item.price)
	fish_price_label.text = str(fish_item.price)
	tunacan_price_label.text = str(tunacan_item.price)
	ball_price_label.text = str(ball_item.price)
	laser_price_label.text = str(laser_item.price)
	comb_price_label.text = str(comb_item.price)
	brush_price_label.text = str(brush_item.price)
	
	
	# Agrega los items a tu inventario.
	inventory_resource.items.append(kibble_item)
	inventory_resource.items.append(fish_item)
	inventory_resource.items.append(tunacan_item)
	inventory_resource.items.append(ball_item)
	inventory_resource.items.append(laser_item)
	inventory_resource.items.append(comb_item)
	inventory_resource.items.append(brush_item)
	
	# Actualiza el contador de items.
	items = inventory_resource.items
	update_item()  
	
#boton de muebles para comprar
func _buy_button_pressed(count_labelM, NumM):
	print("esto es NUM: ", NumM)
	if moneditas.coin >= furnitureResource.furnitureList[NumM].costF:#var botonNombre = 
		furnitureResource.furnitureList[NumM].countF += 1
		# Actualizamos el texto del label de cantidad
		count_labelM.text = "Cantidad: %d" % furnitureResource.furnitureList[NumM].countF 
		moneditas.coin -=  furnitureResource.furnitureList[NumM].costF 		
		coins_label.text = str(moneditas.coin)
		ResourceSaver.save(furnitureResource, "res://Save/Furniture/furnitureSave.tres") 
		
	
	
#actualiza los botones para que este disable si no hay dinero para comprarlos
func update_buttons():
	buy_kibble_button.disabled = moneditas.coin < items[0].price
	buy_fish_button.disabled = moneditas.coin < items[1].price
	buy_tunacan_button.disabled = moneditas.coin < items[2].price
	buy_ball_button.disabled = moneditas.coin < items[3].price
	buy_laser_button.disabled = moneditas.coin < items[4].price
	buy_comb_button.disabled = moneditas.coin < items[5].price
	buy_brush_button.disabled = moneditas.coin < items[6].price
	#for i in range(0,NumMueble-1):
		#if moneditas.coin < furnitureResource.furnitureList[i].costF:
			#var nodoBoton = get_node("comprar" + str(i))
			#if not nodoBoton == null:
			#	nodoBoton.disabled
		#else:
			#pass#



func buy_kibble():
	var kibble_item = items[0]
	if moneditas.coin >= kibble_item.price:  # Verifica si tienes suficientes monedas
		kibble_item.count += 1
		kibble_label.text = str(kibble_item.count)
		moneditas.coin -= kibble_item.price
		coins_label.text = str(moneditas.coin)
		update_item()
		update_buttons()
		


	
func buy_fish():
	var fish_item = items[1] 
	if moneditas.coin >= fish_item.price:
		fish_item.count += 1
		fish_label.text = str(fish_item.count)
		moneditas.coin -= fish_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()

	
func buy_tunacan():
	var tunacan_item = items[2] 
	if moneditas.coin >= tunacan_item.price:
		tunacan_item.count += 1
		tunacan_label.text = str(tunacan_item.count)
		moneditas.coin -= tunacan_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()


func buy_ball():
	var ball_item = items[3] 
	if moneditas.coin >= ball_item.price:
		ball_item.count += 1
		ball_label.text = str(ball_item.count)
		moneditas.coin -= ball_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()


func buy_laser():
	var laser_item = items[4] 
	if moneditas.coin >= laser_item.price:
		laser_item.count += 1
		laser_label.text = str(laser_item.count)
		moneditas.coin -= laser_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()


func buy_comb():
	var comb_item = items[5] 
	if moneditas.coin >= comb_item.price:
		comb_item.count += 1
		comb_label.text = str(comb_item.count)
		moneditas.coin -= comb_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()

	
func buy_brush():
	var brush_item = items[6] 
	if moneditas.coin >= brush_item.price:
		brush_item.count += 1
		brush_label.text = str(brush_item.count)
		moneditas.coin -= brush_item.price
		coins_label.text = str(moneditas.coin)
		update_item()  
		update_buttons()


func _on_button_pressed():
	ResourceSaver.save(furnitureResource, "res://Save/Furniture/furnitureSave.tres")
	set_visible(false)
	get_tree().paused=false
	get_node("../inventario/Item").set_visible(true)
	get_node("../inventario/back").set_visible(true)
	get_node("../inventario/next").set_visible(true)
	get_node("../inventario/Label").set_visible(true)
	get_node("../CanvasLayer/Nombre").set_visible(true)
	get_node("../CanvasLayer/food").set_visible(true)
	get_node("../CanvasLayer/fun").set_visible(true)
	get_node("../CanvasLayer/clean").set_visible(true)
	get_node("../CanvasLayer/comfort").set_visible(true)
	get_node("../CanvasLayer/exercise").set_visible(true)
	SignalManager.michiEggShowHide.emit(1)

	
	
	

func update_item():
	var _item = items[item_index]
	SignalManager.updateItems.emit(0)
	

#Botones para comprar

func _on_buykibble_pressed():
	buy_kibble()

func _on_buy_fish_pressed():
	buy_fish()
	
func _on_buyball_pressed():
	buy_ball()
	
func _on_buylaser_pressed():
	buy_laser()	
	
func _on_buycomb_pressed():
	buy_comb()
	
func _on_buybrush_pressed():
	buy_brush()
	
func _on_buytunacan_pressed():
	buy_tunacan()


#cambia de pestañas entre items y muebles
func _on_items_pressed(): # Muestra los items y oculta los muebles
	items_Container.visible = true
	furnitures_Container.visible = false
	bg_items.visible = true
	bg_furnitures.visible = false
	$Items.visible= false
	$Furnitures.visible= true
	$ScrollContainerNew.hide()
	$ScrollContainerNew/Controlnew.hide()
func _on_furnitures_pressed():
	$Items.visible= true
	items_Container.visible = false
	bg_furnitures.visible = true
	$ScrollContainerNew.show()
	$ScrollContainerNew/Controlnew.show()
	bg_items.visible = false
	furnitures_button.visible =false


func itemsCoinSave():
	ResourceSaver.save(moneditas, "res://Save/moneditas.tres")
	ResourceSaver.save(furnitureResource, "res://Save/Furniture/furnitureSave.tres")
	
func addCoins(coin : int):
	moneditas.coin += coin
	coins_label.text = str(moneditas.coin)
	itemsCoinSave()


