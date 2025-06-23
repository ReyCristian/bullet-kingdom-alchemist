extends Container
class_name Contenedor

@export var columnas: int = 1 : set = set_columnas
@export var tamaño_item = Vector2(16, 16)
@export var espacio_slot = Vector2(2, 2)

var _items: Array = []
@export var grid: Control
@export var mostrar_nivel:bool = false

func _ready():
	set_tamaño()

func set_columnas(value: int) -> void:
	columnas = value
	if not Engine.is_editor_hint():
		_actualizar_tamaño_si_procede()

func _actualizar_tamaño_si_procede():
	if not is_inside_tree(): return
	if not Engine.is_editor_hint() and not is_node_ready(): return
	set_tamaño()

func set_tamaño(tamaño: int = columnas) -> void:
	_items.resize(tamaño)
	_crear_slots()

func agregar(item: Item, index: int) -> Item:
	if not puede_agregar(item,index):
		return item
	var anterior_item = _items[index]
	_items[index] = item
	await _actualizar_slot(index)
	return anterior_item

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

func _actualizar_slot(index: int) ->Signal:
	if _items[index]:
		if mostrar_nivel:
			_items[index].mostrar_nivel()
		else:
			_items[index].ocultar_nivel()
	return _colocar_item(_crear_item(index),index);

func _crear_slots():
	for i in range(_items.size()):
		_colocar_item(_crear_item(i),i)

func _crear_slot(index: int) -> Control:
	var item_vacio = ItemTile.new()
	var slot = ItemRect.new(item_vacio)
	slot.name = "Slot_%d" % index
	slot.contenedor = self;
	slot.indice = index;
	slot.inmobil = true;
	slot.custom_minimum_size = tamaño_item + espacio_slot;
	return slot;

func _crear_item(index: int) -> ItemRect:
	if _items[index] and not Engine.is_editor_hint():
		var item:ItemRect = _items[index].get_rect()
		item.inmobil = false;
		item.contenedor = self;
		item.indice = index;
		item.custom_minimum_size = tamaño_item;
		return item
	return null

func _colocar_item(itemRect: ItemRect, index: int) -> Signal:
	if index < grid.get_child_count():
		var slot = grid.get_child(index)
		if itemRect:
			return itemRect.mover_a_slot(slot, espacio_slot / 2)
	return create_tween().tween_interval(0).finished
			

func _colocar_slot(slot: Control, index: int) -> void:
	if index < grid.get_child_count():
		var viejo_slot = grid.get_child(index)

		for hijo in viejo_slot.get_children():
			if hijo is ItemRect:
				hijo.borrar();

		viejo_slot.queue_free()

	grid.add_child(slot)
	grid.move_child(slot, index)
