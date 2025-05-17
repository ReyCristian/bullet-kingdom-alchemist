extends Container
class_name Contenedor

@export var columnas: int = 1 : set = set_columnas
@export var tamaño_item = Vector2(16, 16)
@export var espacio_slot = Vector2(2, 2)

var _items: Array = []
var grid: Container

func _ready():
	set_tamaño()

func set_columnas(value: int) -> void:
	columnas = value
	_actualizar_tamaño_si_procede()

func _actualizar_tamaño_si_procede():
	if not is_inside_tree(): return
	if not Engine.is_editor_hint() and not is_node_ready(): return
	set_tamaño()

func set_tamaño(tamaño: int = columnas) -> void:
	_items.resize(tamaño)
	_crear_slots()
	

func agregar(item: Item, index: int) -> bool:
	if not puede_agregar(item,index):
		return false
	_items[index] = item
	_actualizar_slot(index)
	print(_items)
	return true

func puede_agregar(item: Item, index: int) -> bool:
	if index < 0 or item == null:
		return false
	return true

func quitar(index: int) -> Item:
	if index < 0 or index > _items.size():
		return null
	var item = _items[index]
	_items[index] = null
	_actualizar_slot(index)
	return item

func get_item(index:int)-> Item:
	if index < 0 or index > _items.size():
		return null
	return _items[index]

func abrir():
	visible = true

func cerrar():
	visible = false

func _actualizar_slots():
	for i in range(_items.size()):
		_actualizar_slot(i)

func _actualizar_slot(index: int):
	_colocar_item(_crear_item(index),index)
	pass

func _crear_slots():
	for child in grid.get_children():
		child.queue_free()
	for i in range(_items.size()):
		_colocar_slot(_crear_slot(i),i)
	for i in range(_items.size()):
		_colocar_item(_crear_item(i),i)

func _crear_slot(index: int) -> Control:
	var item_vacio = ItemTile.new()
	var slot = ItemRect.new(item_vacio)
	slot.name = "Slot_%d" % index
	slot.contenedor = self;
	slot.indice = index;
	slot.custom_minimum_size = tamaño_item + espacio_slot;
	return slot

func _crear_item(index: int) -> ItemRect:
	if _items[index]:
		var item = _items[index].get_rect()
		item.contenedor = self;
		item.indice = index;
		item.custom_minimum_size = tamaño_item;
		return item
	print(null, " en ",index)
	return null

func _colocar_item(itemRect: ItemRect, index: int) -> void:
	print(index , itemRect)
	if index < grid.get_child_count():
		var slot = grid.get_child(index)
		for i in slot.get_children():
			i.queue_free()
		if itemRect:
			slot.add_child(itemRect)
			itemRect.set_position(espacio_slot/2)

func _colocar_slot(slot: Control, index: int) -> void:
	if index < grid.get_child_count():
		grid.get_child(index).queue_free()
	grid.add_child(slot)
	grid.move_child(slot, index)
