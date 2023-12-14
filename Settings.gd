extends Node2D
var savePathColorGui = "res://Save/GUI/"
var saveFileColorGui= "SaveGUIColor"
var topGui
var botGui
var statsFoodGUI
var statsCleanGUI
var statsExerciseGUI
var statsComfortGUI
var statsFunGUI
var actualColor : ColorGUI
var colorUser
var relleno
var topGuiMuebles

func _ready():
	loadData()
	topGui = get_parent().get_parent().get_node("TopGui")
	botGui = get_parent().get_node("GuIbottomBackground")
	relleno = get_parent().get_node("ColorRect")
	topGuiMuebles = get_parent().get_parent().get_node("ColorRectTopGUI")
	statsFoodGUI = get_parent().get_parent().get_node("CanvasLayer/food")
	statsCleanGUI = get_parent().get_parent().get_node("CanvasLayer/clean")
	statsExerciseGUI = get_parent().get_parent().get_node("CanvasLayer/exercise")
	statsComfortGUI = get_parent().get_parent().get_node("CanvasLayer/comfort")
	statsFunGUI = get_parent().get_parent().get_node("CanvasLayer/fun")
	topGui.modulate = actualColor.colorGui
	botGui.modulate = actualColor.colorGui
	relleno.modulate = actualColor.colorGui
	topGuiMuebles.modulate = actualColor.colorGui
	statsFoodGUI.set_tint_under(actualColor.colorGui)
	statsCleanGUI.set_tint_under(actualColor.colorGui)
	statsExerciseGUI.set_tint_under(actualColor.colorGui)
	statsComfortGUI.set_tint_under(actualColor.colorGui)
	statsFunGUI.set_tint_under(actualColor.colorGui)
	
	


func _on_edit_color_gui_button_pressed():
	if $ColorPicker.visible:
		$ColorPicker.hide()
		
	else:
		$ColorPicker.show()
		$"Bg-black".show()
		$modalSettings.hide()


func _on_cancel_color_pressed():
	topGui.modulate = actualColor.colorGui
	botGui.modulate = actualColor.colorGui
	relleno.modulate = actualColor.colorGui
	topGuiMuebles.modulate=actualColor.colorGui
	statsFoodGUI.set_tint_under(actualColor.colorGui)
	statsCleanGUI.set_tint_under(actualColor.colorGui)
	statsExerciseGUI.set_tint_under(actualColor.colorGui)
	statsComfortGUI.set_tint_under(actualColor.colorGui)
	statsFunGUI.set_tint_under(actualColor.colorGui)
	$modalSettings.show()
	$ColorPicker.hide()
	$"Bg-black".hide()



func _on_color_picker_color_changed(color):
	topGui.modulate = color
	botGui.modulate = color
	relleno.modulate = color
	topGuiMuebles.modulate= color
	statsFoodGUI.set_tint_under(actualColor.colorGui)
	statsCleanGUI.set_tint_under(actualColor.colorGui)
	statsExerciseGUI.set_tint_under(actualColor.colorGui)
	statsComfortGUI.set_tint_under(actualColor.colorGui)
	statsFunGUI.set_tint_under(actualColor.colorGui)
	colorUser = color
	
	


func _on_confirm_color_pressed():
	$ColorPicker.hide()
	$"Bg-black".hide()
	$modalSettings.show()
	actualColor.colorGui = colorUser
	save()
	
func loadData():
	if ResourceLoader.exists(savePathColorGui + saveFileColorGui + ".tres"):
		actualColor = ResourceLoader.load(savePathColorGui + saveFileColorGui + ".tres")
	else:
		var newColorGui = ColorGUI.new()
		ResourceSaver.save(newColorGui, (savePathColorGui + saveFileColorGui + ".tres" ))
		actualColor = ResourceLoader.load(savePathColorGui + saveFileColorGui + ".tres")
		
func save():
	ResourceSaver.save(actualColor, savePathColorGui + saveFileColorGui + ".tres")
