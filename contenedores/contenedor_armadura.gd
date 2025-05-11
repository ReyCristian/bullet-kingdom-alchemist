extends Contenedor
class_name Contenedor_Armadura

@export var personaje: Personaje

func _ready():
	if personaje and personaje.armadura_equipada:
		items = personaje.armadura_equipada
	else:
		push_error("Contenedor_Armadura: personaje no válido o sin armadura_equipada.")

	set_tamaño(1, 3)

func agregar(item: Item, fila: int, columna: int) -> bool:
	if item is Armadura:
		var slot = item.obtener_slot()
		if slot >= 0 and slot < 3:
			personaje.equipar(item, slot)
			_actualizar_slot(slot)
			return true
	return false

func quitar(fila: int, columna: int) -> Item:
	var index := calcular_index(fila, columna)
	if index < 0:
		return null
	var item = items[index]
	if item is Armadura:
		personaje.desequipar_armadura(index)
		_actualizar_slot(index)
		return item
	return null
