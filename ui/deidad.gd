extends Control
class_name Deidad

var inventario: Inventario
var forja: Forja
var basurero: Basurero

func _ready():
	for child in get_children():
		if child is Inventario:
			inventario = child
		elif child is Forja:
			forja = child
		elif child is Basurero:
			basurero = child
