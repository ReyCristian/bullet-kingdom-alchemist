@tool
extends TextureRect
class_name ItemRect

@export var icono_default: ItemIcon = ItemTile.new()
@export var contenedor: Contenedor
@export var indice: int = -1

@export var inmobil: bool = false

signal clickeado(item_rect: ItemRect)
signal clickeado_secundario(item_rect: ItemRect)

var arrastrando :bool = false;

func _init(icono: ItemIcon = null) -> void:
	if icono:
		icono_default = icono;

func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mouse_entered.connect(_al_entrar_mouse)
	mouse_exited.connect(_al_salir_mouse)
	reset_icono()

func set_icono(texture_nueva: Texture2D) -> void:
	texture = texture_nueva
	
func load_icono(icono: ItemIcon)->void:
	if icono:
		icono_default = icono;
		reset_icono()

func reset_icono() -> void:
	texture = icono_default.get_icono()

func get_item()-> Item:
	return contenedor.get_item(indice)

func pop()-> Item:
	return contenedor.quitar(indice)

func _gui_input(event: InputEvent) -> void:
	if inmobil:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clickeado.emit(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			clickeado_secundario.emit(self)

func _get_drag_data(_position: Vector2):
	if inmobil:
		return null
	iniciar_drag()
	var preview = _crear_preview()
	set_drag_preview(preview)
	return self

func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	if not data or not data is ItemRect:
		return false;
	var item_recibido = data as ItemRect
	return contenedor.puede_agregar(item_recibido.get_item(),indice)

func _drop_data(_position: Vector2, data: Variant) -> void:
	if _can_drop_data(_position,data):
		var item_recibido = data as ItemRect
		var contenedor_orig = item_recibido.contenedor
		var index_origen = item_recibido.indice
		var item = item_recibido.pop()
		if item != null:
			var i = await contenedor.agregar(item,indice)
			await contenedor_orig.agregar(i,index_origen)

func _crear_preview() -> Control:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.size = size
	preview.modulate = Color(1, 1, 1, 0.5)
	return preview
	
func mover_a_slot(nuevo_slot: Control, pos_objetivo: Vector2) -> Signal:
	var pos_global = null
	if get_parent():
		pos_global = global_position
		get_parent().remove_child(self)
	nuevo_slot.add_child(self)
	if(pos_global):
		set_global_position(pos_global)
	else:
		set_position(pos_objetivo);
	var tween = create_tween()
	tween.tween_property(self, "position", pos_objetivo, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if (custom_minimum_size != size):
		size = custom_minimum_size
	return tween.finished

func borrar():
	Alquimia.regresar_al_eter(self)

func iniciar_drag():
	arrastrando = true
	if contenedor is Basurero:
		contenedor.cancelar_vaciado()
		
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if arrastrando:
			terminar_drag()

func terminar_drag():
	arrastrando = false
	if contenedor is Basurero:
		contenedor.vaciar(3)
	
func _al_entrar_mouse():
	var item = get_item()
	if item:
		StatsTooltip.mostrar(item.descripcion(), get_global_mouse_position())

func _al_salir_mouse():
	StatsTooltip.ocultar()
