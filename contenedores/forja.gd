extends Contenedor
class_name Forja

@export var recetas: Array[Receta] = []

func _ready():
	set_tamaño(1, 3)

func intentar_fusionar() -> Item:
	var tipos: Array[Item.TipoItem] = []
	for item in items:
		if item:
			tipos.append(item.tipo)

	for receta in recetas:
		if receta.ingredientes == tipos:
			return receta.resultado

	return null
