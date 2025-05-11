extends Contenedor
class_name Contenedor_Cofre

@export var cofre: Cofre

func _ready():
	if cofre:
		items = cofre.items
	set_tamaño(1, 5)
