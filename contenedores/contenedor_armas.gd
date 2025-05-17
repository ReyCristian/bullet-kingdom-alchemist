extends Contenedor
class_name Contenedor_Armas

@export var personaje: Personaje

func _ready():
	print("listo el armas")
	if personaje and personaje.arma_equipada:
		_items = personaje.arma_equipada
	else:
		push_error("Contenedor_Armas: personaje no válido o sin arma_equipada.")
	set_tamaño(2)

func _crear_slots():
	#print(personaje)
	#print(personaje.arma_equipada)
	#print(_items)
	super._crear_slots();
	
func agregar(item: Item, index: int) -> bool:
	if not puede_agregar(item,index):
		return false
	if item is Arma:
		personaje.equipar(item, index)
		_actualizar_slot(index)
		return true
	return false

func quitar(index: int) -> Item:
	if index < 0:
		return null
	var item = personaje.desequipar_arma(index)
	_actualizar_slot(index)
	return item
