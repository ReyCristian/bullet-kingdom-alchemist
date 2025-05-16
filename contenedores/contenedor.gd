extends Control
class_name Contenedor

@export var columnas: int = 1 : set = set_columnas

var items: Array = []

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
	# Este método lo puede implementar cada derivado para personalizar el update visual
	pass

func _crear_slots():
	pass

func _crear_slot(index: int) -> Control:
	var slot = ItemTile.new()
	slot.name = "Slot_%d" % index
	return slot

func _colocar_slot(slot: Control, index: int) -> void:
	# Cada subclase debería implementar cómo se colocan los slots (grid, lista, libre, etc.)
	add_child(slot)
