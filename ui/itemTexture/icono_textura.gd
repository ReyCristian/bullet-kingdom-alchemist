@tool
extends TextureRect
class_name Icono

@export var imagen: Texture2D : set = set_imagen
@export var tamaño_region: Vector2 = Vector2.ZERO : set = set_tamaño_region
@export var margen: Vector2 = Vector2.ZERO : set = set_margen
@export var relleno: Vector2 = Vector2.ZERO : set = set_relleno
@export var celda: Vector2 = Vector2.ZERO : set = set_celda

var modulate_original: Color = Color.WHITE

var seleccionado: bool = false:
	set(value):
		seleccionado = value
		_actualizar_modulate()

var habilitado: bool = true:
	set(value):
		habilitado = value
		_actualizar_modulate()

signal clickeado

func _ready():
	modulate_original = modulate
	_actualizar_icono()

func _notification(what):
	if what == NOTIFICATION_ENTER_TREE:
		_actualizar_icono()

func set_imagen(nueva: Texture2D) -> void:
	imagen = nueva
	_actualizar_icono()

func set_tamaño_region(nuevo: Vector2) -> void:
	tamaño_region = nuevo
	_actualizar_icono()

func set_margen(nuevo: Vector2) -> void:
	margen = nuevo
	_actualizar_icono()

func set_relleno(nuevo: Vector2) -> void:
	relleno = nuevo
	_actualizar_icono()

func set_celda(nueva: Vector2) -> void:
	celda = nueva
	_actualizar_icono()

func _actualizar_icono():
	if not imagen: return

	var tex := AtlasTexture.new()
	tex.atlas = imagen
	
	var posicion_region = margen
	if relleno != Vector2.ZERO:
		posicion_region += Vector2(celda.x * (tamaño_region.x + relleno.x), celda.y * (tamaño_region.y + relleno.y))

	tex.region = Rect2(posicion_region, tamaño_region if tamaño_region != Vector2.ZERO else imagen.get_size())
	texture = tex

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and habilitado:
		clickeado.emit()

func _actualizar_modulate():
	if not habilitado:
		modulate = Color(0.5, 0.5, 0.5) # Gris
	elif seleccionado:
		modulate = Color8(100, 180, 255) # Celeste
	else:
		modulate = modulate_original
