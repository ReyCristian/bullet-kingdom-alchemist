extends Contenedor
class_name Contenedor_Armas

@export var personaje: Personaje

func _ready():
	if personaje and personaje.arma_equipada:
		items = personaje.arma_equipada
	else:
		push_error("Contenedor_Armas: personaje no válido o sin arma_equipada.")

	set_tamaño(1, 2)
	
	
func agregar(item: Item, fila: int, columna: int) -> bool:
	var index := calcular_index(fila, columna)
	if index < 0:
		return false
	if item is Arma:
		personaje.equipar(item, index)
		_actualizar_slot(index)
		return true
	return false

func quitar(fila: int, columna: int) -> Item:
	var index := calcular_index(fila, columna)
	if index < 0:
		return null
	var item = personaje.desequipar_arma(index)
	_actualizar_slot(index)
	return item
