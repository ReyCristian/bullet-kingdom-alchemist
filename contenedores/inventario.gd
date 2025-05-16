@tool
extends Contenedor
class_name Inventario

@export var filas: int = 5 : set = set_filas

var grid: GridContainer
var grid_vacio: GridContainer

func _ready():
	set_tamaño()
	items[2]=load("res://items/armas/gun.tres")

func set_filas(value: int) -> void:
	filas = value
	_actualizar_tamaño_si_procede()
	
func set_tamaño(ignore: int = 0) -> void:
	if not is_instance_valid(grid):
		grid = GridContainer.new()
		grid.name = "GridItems"
		grid.set("theme_override_constants/h_separation", 0)
		grid.set("theme_override_constants/v_separation", 0)
		add_child(grid)
	
	if not is_instance_valid(grid_vacio):
		grid_vacio = GridContainer.new()
		grid_vacio.name = "GridVacio"
		grid_vacio.set("theme_override_constants/h_separation", 0)
		grid_vacio.set("theme_override_constants/v_separation", 0)
		add_child(grid_vacio)
	
	grid_vacio.columns = columnas
	grid.columns = columnas
	super.set_tamaño(filas * columnas)

func _crear_slots():
	for child in grid_vacio.get_children():
		child.queue_free()
	for i in range(items.size()):
		grid_vacio.add_child(_crear_slot(i))

func colocar_slot(slot: Control, index: int) -> void:
	grid.add_child(slot)

func calcular_index(fila: int, columna: int) -> int:
	if fila < 0 or fila >= filas or columna < 0 or columna >= columnas:
		return -1
	return fila * columnas + columna
