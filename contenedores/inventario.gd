@tool
extends Contenedor
class_name Inventario

@export var filas: int = 5 : set = set_filas

func _ready():
	set_tamaño()
	agregar(load("res://items/armas/gun.tres"),calcular_index(0,0))

func set_filas(value: int) -> void:
	filas = value
	_actualizar_tamaño_si_procede()
	
func set_tamaño(_ignore: int = 0) -> void:
	if not is_instance_valid(grid_vacio):
		grid_vacio = GridContainer.new()
		grid_vacio.name = "GridVacio"
		grid_vacio.set("theme_override_constants/h_separation", 0)
		grid_vacio.set("theme_override_constants/v_separation", 0)
		add_child(grid_vacio)
		
	if not is_instance_valid(grid):
		grid = GridContainer.new()
		grid.name = "GridItems"
		grid.set("theme_override_constants/h_separation", espacio_slot.x)
		grid.set("theme_override_constants/v_separation", espacio_slot.y)
		grid.position = espacio_slot/2
		add_child(grid)
	
	grid_vacio.columns = columnas
	grid.columns = columnas
	super.set_tamaño(filas * columnas)

func calcular_index(fila: int, columna: int) -> int:
	if fila < 0 or fila >= filas or columna < 0 or columna >= columnas:
		return -1
	return fila * columnas + columna
