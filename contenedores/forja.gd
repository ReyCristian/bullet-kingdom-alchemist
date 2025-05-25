extends Contenedor
class_name Forja

@export var recetas: Array[Receta] = []
var fusionando:bool = false;

func _ready():
	set_tamaño(2)
	
func agregar(item: Item, _index: int = -1) -> Item:
	if fusionando:
		return item
	fusionando = true;
	_items[1] = _items[0];
	_items[0] = item;
	await _actualizar_slot(0)
	var fusion = intentar_fusionar()
	if fusion:
		_items[0].borrar()
		_items[1].borrar()
		_items[1] = null
		_items[0] = fusion;
		await _actualizar_slot(0)
		_items[0] = null
		fusionando = false;
		return fusion
	fusionando = false;
	return _items[1]

func intentar_fusionar() -> Item:
	var tipos: Array[TipoItem] = []
	for item in _items:
		if item:
			tipos.append(item.tipo)

	for receta in recetas:
		if receta.ingredientes == tipos:
			return Alquimia.fabricar(receta.resultado)
	return null
