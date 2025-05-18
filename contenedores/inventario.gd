@tool
extends Contenedor
class_name Inventario

@export var filas: int = 5 : set = set_filas

@export var contenedor_click_secundario: Contenedor

func _ready():
	set_tamaño()
	agregar(load("res://items/creados/gun.tres").duplicate(), 1)
	agregar(load("res://items/creados/gun.tres").duplicate(), 5)

func set_filas(value: int) -> void:
	filas = value
	_actualizar_tamaño_si_procede()
	
func set_tamaño(_ignore: int = 0) -> void:		
	if not is_instance_valid(grid):
		grid = GridContainer.new()
		grid.set("theme_override_constants/h_separation", 0)
		grid.set("theme_override_constants/v_separation", 0)
		add_child(grid)
		
	grid.columns = columnas
	super.set_tamaño(filas * columnas)

func calcular_index(fila: int, columna: int) -> int:
	if fila < 0 or fila >= filas or columna < 0 or columna >= columnas:
		return -1
	return fila * columnas + columna
	
func _crear_slots():
	for child in grid.get_children():
		child.queue_free()
	for i in range(_items.size()):
		_colocar_slot(_crear_slot(i),i)
	super._crear_slots()
	
func agregar(item: Item, index: int = -1) -> Item:
	if index == -1:
		index = _items.find(null)
	return super.agregar(item,index)

func puede_agregar(item: Item, index: int) -> bool:
	if index == -1:
		return _items.any(func(x): return x == null)
	return super.puede_agregar(item, index)

func _crear_item(index: int) -> ItemRect:
	var item = super._crear_item(index);
	if item is ItemRect:
		item.clickeado_secundario.connect(enviar_item)
	return item;

func enviar_item(item: ItemRect):
	if contenedor_click_secundario.visible:
		var index = item.indice;
		var retorno = contenedor_click_secundario.agregar(item.pop(),-1)
		agregar(retorno,index)
	pass
