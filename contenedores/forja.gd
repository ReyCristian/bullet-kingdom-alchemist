extends Contenedor
class_name Forja

@export var recetas: Array[Receta] = []
var fusionando:bool = false;

func _ready():
	set_tamaño(2)
	
func puede_agregar(_item:Item,_index:int):
	return true
	
func agregar(item: Item, _index: int = -1) -> Item:
	if fusionando:
		return item
	fusionando = true;
	_items[1] = _items[0];
	_items[0] = item;
	await _actualizar_slot(0)
	var fusion = intentar_fusionar()
	if fusion:
		_items[1] = null
		_items[0] = fusion;
		await _actualizar_slot(0)
		_items[0] = null
		fusionando = false;
		return fusion
	fusionando = false;
	return _items[1]

func intentar_fusionar() -> Item:
	if _items[0]==null or _items[1]==null\
		or _items[0].nivel == 0\
		or _items[0].nivel != _items[1].nivel:
			return null;
	
	var tipos: Array[TipoItem] = []
	for item in _items:
		if item:
			tipos.append(item.tipo)

	for receta in recetas:
		if receta.ingredientes == tipos:
			return Alquimia.combinar(_items[0],_items[1],receta.resultado)
	return null
