extends CanvasLayer

func _ready():
	SignalManager.manageStatusBars.connect(update)
	$food.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	$fun.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	$clean.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	$comfort.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	$exercise.fill_mode = TextureProgressBar.FILL_BOTTOM_TO_TOP
	

func update(michi : MichiData, huevo : HuevoData, type : int):
	if type == 0:
		$Nombre.text = michi.name
		$Category.text = michi.category
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
		
	if $food.value >= 70:
		$food.set_tint_progress(Color("#02e606"))
	elif $food.value >= 40:
		$food.set_tint_progress(Color("#f7ff0f"))
	elif $food.value < 40:
		$food.set_tint_progress(Color("#ff0000"))
		
	if $fun.value >= 70:
		$fun.set_tint_progress(Color("#02e606"))
	elif $fun.value >= 40:
		$fun.set_tint_progress(Color("#f7ff0f"))
	elif $fun.value < 40:
		$fun.set_tint_progress(Color("#ff0000"))
		
	if $clean.value >= 70:
		$clean.set_tint_progress(Color("#02e606"))
	elif $clean.value >= 40:
		$clean.set_tint_progress(Color("#f7ff0f"))
	elif $clean.value < 40:
		$clean.set_tint_progress(Color("#ff0000"))
		
	if $comfort.value >= 70:
		$comfort.set_tint_progress(Color("#02e606"))
	elif $comfort.value >= 40:
		$comfort.set_tint_progress(Color("#f7ff0f"))
	elif $comfort.value < 40:
		$comfort.set_tint_progress(Color("#ff0000"))
	
	if $exercise.value >= 70:
		$exercise.set_tint_progress(Color("#02e606"))
	elif $exercise.value >= 40:
		$exercise.set_tint_progress(Color("#f7ff0f"))
	elif $exercise.value < 40:
		$exercise.set_tint_progress(Color("#ff0000"))
		
		
		
		
	elif type == 1:
		$Nombre.text = str(huevo.taps)
		$food.visible = false
		$fun.visible = false
		$clean.visible = false
		$comfort.visible = false
		$exercise.visible = false
		
	

