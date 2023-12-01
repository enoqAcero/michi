extends Sprite2D
var caminadora
var nuevoColor

# Called when the node enters the scene tree for the first time.
func _ready():
	caminadora = $"."
	
	
	

func _on_color_picker_button_color_changed(color):
	caminadora.modulate = color
