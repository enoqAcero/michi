extends Area2D

var rng = RandomNumberGenerator.new()
var probPos
var rand

func _process(_delta):
	randomize()
	rand = rng.randi_range(1,100)
	probPos = rng.randi_range(3,12)
	if rand > 50:
		position.y += probPos
	else:
		position.y -= probPos
		
	position.x -= get_parent().speed/3
	

	
