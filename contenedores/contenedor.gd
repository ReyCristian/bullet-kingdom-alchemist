extends GridContainer
class_name Contenedor

@export var filas: int = 1
@export var columnas: int = 1

var _filas: int
var _columnas: int
var items: Array = []

func _ready():
	set_tamaño(filas, columnas)

func set_tamaño(f: int, c: int) -> void:
	_filas = f
	_columnas = c
	columns = c
	items.resize(f * c)

	# Limpiar nodos existentes (por si se reutiliza o recarga)
	for child in get_children():
		child.queue_free()

	# Crear slots vacíos
	for i in range(items.size()):
		items[i] = null
		var slot = _crear_slot(i)
		add_child(slot)

func agregar(item: Item, fila: int, columna: int) -> bool:
	var index = calcular_index(fila, columna)
	if index < 0:
		return false
	items[index] = item
	_actualizar_slot(index)
	return true

func quitar(fila: int, columna: int) -> Item:
	var index = calcular_index(fila, columna)
	if index < 0:
		return null
	var item = items[index]
	items[index] = null
	_actualizar_slot(index)
	return item

func _actualizar_slot(index: int):
	var slot = get_child(index)
	# Actualizar ícono, color, etc.
	pass

func _crear_slot(index: int) -> Control:
	var slot = ItemTile.new()
	slot.name = "Slot_%d" % index
	return slot

func calcular_index(fila: int, columna: int) -> int:
	if fila < 0 or fila >= _filas or columna < 0 or columna >= _columnas:
		return -1
	return fila * _columnas + columna
	
func abrir():
	visible = true

func cerrar():
	visible = false
