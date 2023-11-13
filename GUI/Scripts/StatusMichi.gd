extends CanvasLayer

func _ready():
	SignalManager.manageStatusBars.connect(update)

func update(michi : MichiData, huevo : HuevoData, type : int):
	if type == 0:
		$Nombre.text = michi.name
		$promedio.value = ((michi.food + michi.fun + michi.clean + michi.comfort + michi.exercise)/5) 
		$food.visible = true
		$fun.visible = true
		$clean.visible = true
		$comfort.visible = true
		$exercise.visible = true
		$food.value = michi.food
		$fun.value = michi.fun
		$clean.value = michi.clean
		$comfort.value = michi.comfort
		$exercise.value = michi.exercise
	elif type == 1:
		$Nombre.text = str(huevo.taps)
		$promedio.value = (huevo.taps * 100)/1000
		$food.visible = false
		$fun.visible = false
		$clean.visible = false
		$comfort.visible = false
		$exercise.visible = false
		
	

