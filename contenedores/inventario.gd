@tool
extends Contenedor
class_name Inventario

@export var filas: int = 5 : set = set_filas

@export var contenedores_click_secundario: Array[Contenedor]

func _ready():
	set_tamaño()
	if Engine.is_editor_hint():
		return
	agregar(Alquimia.duplicar_item(load("res://items/creados/gun.tres")), 1)
	agregar(Alquimia.duplicar_item(load("res://items/creados/espada.tres")), 5)
	agregar(Alquimia.duplicar_item(load("res://items/creados/escudo.tres")), 8)
	agregar(Alquimia.duplicar_item(load("res://items/creados/chapita.tres")), 9)

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
	return await super.agregar(item,index)
	
func puede_agregar(item: Item, index: int=-1) -> bool:
	if index == -1:
		return _items.any(func(x): return x == null)
	return super.puede_agregar(item, index)

func _crear_item(index: int) -> ItemRect:
	var item = super._crear_item(index);
	if item is ItemRect and  not item.clickeado_secundario.is_connected(enviar_item):
		item.clickeado_secundario.connect(enviar_item)
	return item;

func enviar_item(item: ItemRect):
	if item.contenedor != self:
		if puede_agregar(item.get_item()):
			agregar(item.pop())
		return
	for contenedor_click_secundario in contenedores_click_secundario:
		if contenedor_click_secundario.is_visible_in_tree():
			var index = item.indice;
			var retorno = await contenedor_click_secundario.agregar(item.pop(),-1)
			await agregar(retorno,index)
			if retorno != item:
				return
	pass
