extends Resource

class_name MichiData

@export var name = "Suki"
@export var food = 100
@export var fun = 100
@export var clean = 100
@export var comfort = 100
@export var exercise = 100


func change_comida(value : int):
	food += value
