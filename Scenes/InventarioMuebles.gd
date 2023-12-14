extends Node2D
var furnitureResource = preload("res://Save/Furniture/furnitureSave.tres")
var label_settings = preload("res://tipoNum.tres")
var clickMueble = preload("res://Scenes/Scripts/clickMueble.gd")

var numMueble = 0
var vbox

func _ready():
	vbox = $ScrollContainer/Control/VBoxContainer
	mostrarMuebleInv()

func mostrarMuebleInv():
	
	# Itera sobre la lista de muebles.
	for furniture in furnitureResource.furnitureList:
		# Verifica si la cantidad del mueble es mayor a 0.
		if furniture.countF > 0:
			# Crea un nuevo HBoxContainer para este mueble.
			var hbox = HBoxContainer.new()
			
			
			var character = CharacterBody2D.new()
			character.name = "Mueble" + str(numMueble)
			hbox.add_child(character)
			print("Creando mueble con índice: " + str(numMueble))
			# Crea un Sprite2D para el mueble.
			var sprite = Sprite2D.new()
			sprite.texture = furniture.spriteF
			# Si el mueble tiene más de un frame, ajusta la región del sprite para mostrar solo el primer frame.
			if furniture.frameNum > 1:
				var frame_width = sprite.texture.get_width() / furniture.frameNum
				sprite.region_enabled = true
				sprite.region_rect = Rect2(0, 0, frame_width, sprite.texture.get_height())
			character.add_child(sprite)
			
			var area1 = Area2D.new()
			area1.name = "AreaMueble" + str(numMueble)
			character.add_child(area1)
			
			var colision1 = CollisionShape2D.new()
			var new_shape = CircleShape2D.new()
			new_shape.radius= 35
			colision1.set_shape(new_shape) 
			area1.add_child(colision1)
			
			
			
			# Crea un Label para la cantidad.
			var label = Label.new()
			label.name = "contadorM"
			label.text = str(furniture.countF)
			label.label_settings = label_settings	
			
			hbox.add_child(label)
			
			character.set_script(clickMueble)
			
			# Añade el HBoxContainer al VBoxContainer.
			vbox.add_child(hbox)
		numMueble += 1
		
