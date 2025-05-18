extends Contenedor
class_name ContenedorItemsSueltos

signal tomar_item(item: Item)

func _ready() -> void:
	if not is_instance_valid(grid):
		grid = Control.new()
		add_child(grid)

func agregar(item: Item, index: int = 0) -> Item:
	return item

func puede_agregar(item: Item, index: int) -> bool:
	return false;
	
func soltar(item:Item, pos:Vector2) -> ItemRect:
	_items.append(item);
	var obj = _crear_item(_items.size() - 1)
	obj.global_position = pos
	obj.mover_a_slot(grid, pos)
	obj.mouse_entered.connect(_on_item_mouse_entered.bind(item),ConnectFlags.CONNECT_ONE_SHOT)
	return obj
	
func _on_item_mouse_entered(item: Item):
	tomar_item.emit(item)
	pass
