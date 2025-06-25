extends Contenedor
class_name ContenedorItemsSueltos

signal tomar_item(item: Item)

func _ready() -> void:
	if not is_instance_valid(grid):
		grid = Control.new()
		add_child(grid)

func agregar(item: Item, _index: int = 0) -> Item:
	return item

func puede_agregar(_item: Item, _index: int) -> bool:
	return false;
	
func quitar(i):
	(_items[i] as Item).get_rect().mouse_entered.disconnect(_on_item_mouse_entered)
	_items[i] = null;
	
func soltar(item: Item, pos: Vector2) -> ItemRect:
	var index := _items.find(null)
	if index == -1:
		_items.append(item)
		index = _items.size() - 1
	else:
		_items[index] = item

	var obj = _crear_item(index)
	obj.mover_a_slot(grid, pos)
	obj.mouse_entered.connect(_on_item_mouse_entered.bind(item), ConnectFlags.CONNECT_ONE_SHOT)
	item.tiempoVida(20.0)
	return obj

func _on_item_mouse_entered(item: Item) -> void:
	#print("cancelando "+item.nombre)
	item.cancelarBorrado()
	_items[item.get_rect().indice] = null;
	tomar_item.emit(item)
