extends Sprite2D

var caminadoraColor
# Called when the node enters the scene tree for the first time.
func _ready():
	caminadoraColor = $Sprite2D

func _on_color_picker_button_color_changed(color):
	caminadoraColor.modulate = color
