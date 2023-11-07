extends CanvasLayer

func _ready():
	SignalManager.manageStatusBars.connect(update)

func update(michi : MichiData):
	$Nombre.text = michi.name
	$promedio.value = ((michi.food + michi.fun + michi.clean + michi.comfort + michi.exercise)/5) 
	$food.value = michi.food
	$fun.value = michi.fun
	$clean.value = michi.clean
	$comfort.value = michi.comfort
	$exercise.value = michi.exercise
