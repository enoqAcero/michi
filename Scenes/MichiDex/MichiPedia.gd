extends Node2D

var savePath = "res://Save/MichiDex/michiDexSave.tres"

var maxMichiNumber = 61#GlobalVariables.maxMichiNumber
var michiDex : MichiDex

var maxPanel = maxMichiNumber#GlobalVariables.maxMichiNumber
var PanelName
var cornerRadius = 10


func _ready():
	loadData()
	setDex()
	var botonDex = $"../inventario".get_node( "MichiPedia")
	botonDex.pressed.connect(_on_button_pressed)
	SignalManager.michiDexUpdate.connect(michiDexUpdate)
	

		

func loadData():
	if ResourceLoader.exists(savePath):
			michiDex = ResourceLoader.load(savePath)
	else:
		var newMichDex = MichiDex.new()
		ResourceSaver.save(newMichDex, savePath)
		michiDex = ResourceLoader.load(savePath)
		
			
func save():
	ResourceSaver.save(michiDex, savePath)

func michiDexUpdate(michiType : String):
	for i in range (0, maxMichiNumber):
		if michiDex.michiIndex[i].type == michiType and michiDex.michiIndex[i].active == false:
			michiDex.michiIndex[i].active = true
			save()
			loadData()
			setDex()
			break
	
func setDex():
	for i in range (0, maxPanel):
		PanelName = get_node("ScrollContainer/Control/VBoxContainer/Panel"+str(i))
		var style = StyleBoxFlat.new()
		
		var hue = i/float(maxPanel)
		var color = Color.from_hsv(hue,1,1)
		style.bg_color = color
		
		style.corner_radius_bottom_left = cornerRadius
		style.corner_radius_bottom_right = cornerRadius
		style.corner_radius_top_left = cornerRadius
		style.corner_radius_top_right = cornerRadius
		
		PanelName.set("theme_override_styles/panel", style)		

	for i in range (0, maxMichiNumber):
		#$ScrollContainer/Control/VBoxContainer/Panel2/MichiContainer/michi.texture = michiDex.michiIndex[4].sprite.texture
		if michiDex.michiIndex[i].active == false:
			var michi = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer/michi")
			var nombre = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer/nombre")
			nombre.text = "??????"
			michi.modulate = Color("#000000")
		if michiDex.michiIndex[i].active == true:
			var michi = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer/michi")
			var nombre = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer/nombre")
			nombre.text = "Michi " + michiDex.michiIndex[i].type 
			michi.modulate = Color(1,1,1,1)
		var label = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer/numero")
		label.text = str(i+1)
		var containerName = get_node("ScrollContainer/Control/VBoxContainer/Panel" + str(i) + "/MichiContainer")
		containerName.add_theme_constant_override("separation", 50)
		#containerName.set_theme_constant_override("separation", 60)

func _on_button_pressed():
	if visible == false:
		set_visible(true)
		var parentOfBtn = get_parent().get_node("inventario")
		parentOfBtn.get_node("next").disabled = true
		parentOfBtn.get_node("back").disabled = true
		parentOfBtn.get_node("Settings").disabled = true
		parentOfBtn.get_node("Rooms").disabled = true
		get_parent().get_node("inventario/TextureButton").disabled = true

	elif visible == true:
		set_visible(false)
		var parentOfBtn = get_parent().get_node("inventario")
		parentOfBtn.get_node("next").disabled = false
		parentOfBtn.get_node("back").disabled = false
		parentOfBtn.get_node("Settings").disabled = false
		parentOfBtn.get_node("Rooms").disabled = false
		get_parent().get_node("inventario/TextureButton").disabled = false
		
