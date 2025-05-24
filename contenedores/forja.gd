extends Contenedor
class_name Forja

@export var recetas: Array[Receta] = []

func _ready():
	set_tamaño(3)

func intentar_fusionar() -> Item:
	var tipos: Array[TipoItem] = []
	for item in _items:
		if item:
			tipos.append(item.tipo)

	for receta in recetas:
		if receta.ingredientes == tipos:
			return fabricar(receta.resultado)
	return null
	
func fabricar(tipo: TipoItem)-> Item:
	return null;
