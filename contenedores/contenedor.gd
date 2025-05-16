extends Control
class_name Contenedor

@export var columnas: int = 1 : set = set_columnas
@export var tamaño_item = Vector2(16, 16)
@export var espacio_slot = Vector2(2, 2)

var items: Array = []
var grid: Control
var grid_vacio: Control

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
	items.resize(tamaño)
	_crear_slots()
	

func agregar(item: Item, index: int) -> bool:
	if index < 0:
		return false
	items[index] = item
	_actualizar_slot(index)
	return true

func quitar(index: int) -> Item:
	if index < 0:
		return null
	var item = items[index]
	items[index] = null
	_actualizar_slot(index)
	return item

func abrir():
	visible = true

func cerrar():
	visible = false

func _actualizar_slots():
	for i in range(items.size()):
		_actualizar_slot(i)

func _actualizar_slot(index: int):
	_colocar_item(_crear_item_slot(index),index)
	pass

func _crear_slots():
	for child in grid_vacio.get_children():
		child.queue_free()
	for child in grid.get_children():
		child.queue_free()
	for i in range(items.size()):
		_colocar_slot(_crear_slot(i),i)
	for i in range(items.size()):
		_colocar_item(_crear_item_slot(i),i)

func _crear_slot(index: int) -> Control:
	var item_vacio = ItemTile.new()
	item_vacio.set_tile(Vector2(18,1))
	var slot = ItemRect.new(item_vacio)
	slot.name = "Slot_%d" % index
	slot.custom_minimum_size = tamaño_item+espacio_slot;
	return slot

func _crear_item_slot(index: int) -> Control:
	var slot:Control;
	if items[index]:
		slot = ItemRect.new(items[index].icono)
		slot.name = "Item_%d" % index
	else:
		slot = Control.new()
		slot.name = "Aire_%d" % index
	slot.custom_minimum_size = tamaño_item;
	return slot

func _colocar_item(itemRect: Control, index: int) -> void:
	if index < grid.get_child_count():
		grid.get_child(index).queue_free()
	grid.add_child(itemRect)
	grid.move_child(itemRect, index)

func _colocar_slot(slot: Control, index: int) -> void:
	if index < grid.get_child_count():
		grid_vacio.get_child(index).queue_free()
	grid_vacio.add_child(slot)
	grid_vacio.move_child(slot, index)
