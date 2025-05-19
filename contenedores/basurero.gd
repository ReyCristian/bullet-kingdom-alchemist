extends Contenedor
class_name Basurero

@export var tacho: TextureRect

var _tween_vaciado: Tween = null


func _ready():
	set_tamaño(1)
	#espacio_slot = (tamaño_item + espacio_slot)

func agregar(item: Item, _columna: int = 0) -> Item:
	_agregar_async(item)
	return null

func _agregar_async(item: Item) -> void:
	if item != null:
		await vaciar(0.1)
		_items[0] = item
		_actualizar_slot(0)
		vaciar(3)

func puede_agregar(item:Item,index:int):
	return true

func quitar(_columna: int) -> Item:
	cancelar_vaciado()
	var restaurado = _items[0] 
	_items[0] = null
	return restaurado

func _crear_slot(_index: int) -> Control:
	var icono_tacho = ItemIcon.new()
	icono_tacho.icono = tacho.texture
	tacho = ItemRect.new(icono_tacho)
	tacho.name = "Slot_%d" % _index
	tacho.contenedor = self;
	tacho.indice = _index;
	tacho.inmobil = true;
	tacho.custom_minimum_size = tamaño_item + espacio_slot;
	return tacho;
	
func _crear_slots():
	for child in grid.get_children():
		child.queue_free()
	for i in range(_items.size()):
		_colocar_slot(_crear_slot(i),i)

func _actualizar_slot(index: int) -> void:
	super._actualizar_slot(index)
	pass  # No se actualiza visualmente
	
var ejecucion_vaciado=0

func vaciar(duracion: float = 0.3) -> Signal:
	ejecucion_vaciado+=1;
	if _tween_vaciado:
		_tween_vaciado.kill()

	_tween_vaciado = create_tween()

	var a_borrar := []

	for child in tacho.get_children():
		if child is Control and not child.is_queued_for_deletion():
			child.modulate.a = 1.0
			_tween_vaciado.parallel().tween_property(child, "modulate:a", 0.0, duracion)\
				.set_ease(Tween.EASE_IN)
			a_borrar.append(child)

	_tween_vaciado.tween_callback(func():
		for child in a_borrar:
			if is_instance_valid(child):
				child.queue_free()
)
	return _tween_vaciado.finished

func cancelar_vaciado() -> void:
	if _tween_vaciado:
		_tween_vaciado.kill()
		_tween_vaciado = null
	for child in tacho.get_children():
		if child is Control:
			child.scale = Vector2.ONE
			child.rotation = 0
			child.modulate.a = 1.0
