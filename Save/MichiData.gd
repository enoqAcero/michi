extends Resource
class_name MichiData

@export var nombre = "Suki"
@export var comida = 100
@export var diversion = 100
@export var limpieza = 100
@export var comodidad = 100
@export var energia = 100

func change_comida(value : int):
	comida += value
