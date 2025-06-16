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
	if _items[0] == null or _items[1] == null \
		or _items[0].nivel == 0 \
		or _items[0].nivel != _items[1].nivel:
		return null

	var tipo_a = _items[0].tipo
	var tipo_b = _items[1].tipo
	
	var i = 0

	for receta in recetas:
		if receta == null \
			or receta.ingredientes[0]==null\
			or receta.ingredientes[1]==null\
			or receta.resultado==null:
				continue
		var ing := receta.ingredientes
		
		print(i," ",ing[0].nombre," + ",ing[1].nombre," = ",receta.resultado.nombre)
		i+=1;
		if (ing[0] == tipo_a and ing[1] == tipo_b) or (ing[0] == tipo_b and ing[1] == tipo_a):
			return Alquimia.combinar(_items[0], _items[1], receta.resultado)

	return null
