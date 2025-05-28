extends Contenedor
class_name Contenedor_Armas

@export var personaje: Personaje

func _ready():
	if personaje and personaje.arma_equipada:
		_items = personaje.arma_equipada
	else:
		push_error("Contenedor_Armas: personaje no válido o sin arma_equipada.")
	set_tamaño(2)

#func _crear_slots():
#	super._crear_slots();
	
func puede_agregar(item: Item, index: int) -> bool:
	var habilitado = super.puede_agregar(item,index);
	habilitado = habilitado && item is Arma
	return habilitado
	
func agregar(item: Item, index: int) -> Item:
	if index == -1:
		index = _items.find(null)
	if not puede_agregar(item,index):
		return item
	if item is Arma:
		var e = personaje.equipar(item, index)
		_actualizar_slot(index)
		return e
	return item

func quitar(index: int) -> Item:
	if index < 0:
		return null
	var item = personaje.desequipar_arma(index)
	_actualizar_slot(index)
	return item
