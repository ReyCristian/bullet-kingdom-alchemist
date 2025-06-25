extends Contenedor
class_name Contenedor_Armadura

@export var personaje: Personaje

func _ready():
	if personaje and personaje.armadura_equipada:
		_items = personaje.armadura_equipada
	else:
		push_error("Contenedor_Armadura: personaje no válido o sin armadura_equipada.")

	set_tamaño(3)

func puede_agregar(item: Item, _ignore: int) -> bool:
	if item is Armadura:
		var slot = item.obtener_slot()
		return super.puede_agregar(item,slot);
	return false

func agregar(item: Item, _ignore: int = 0) -> Item:
	if item is Armadura:
		var slot = item.obtener_slot()
		if puede_agregar(item,slot):
			var e = personaje.equipar(item, slot)
			_actualizar_slot(slot)
			return e
	return item

func quitar(index: int) -> Item:
	if index < 0:
		return null
	var item = get_item(index)
	if item is Armadura:
		personaje.desequipar_armadura(index)
		_actualizar_slot(index)
		return item
	return null
