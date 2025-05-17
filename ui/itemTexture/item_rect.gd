extends TextureRect
class_name ItemRect

@export var icono_default: ItemIcon = ItemIcon.new()
@export var contenedor: Contenedor
@export var indice: int = -1

func _init(icono: ItemIcon) -> void:
	icono_default = icono;

func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reset_icono()

func set_icono(texture_nueva: Texture2D) -> void:
	texture = texture_nueva

func reset_icono() -> void:
	texture = icono_default.get_icono()

func get_item()-> Item:
	return contenedor.get_item(indice)

func pop()-> Item:
	return contenedor.quitar(indice)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		set_drag_preview(_crear_preview())
		pass

func _get_drag_data(position: Vector2) -> Variant:
	return self

func _can_drop_data(position: Vector2, data: Variant) -> bool:
	if not data is ItemRect:
		return false;
	var item_recibido = data as ItemRect
	return contenedor.puede_agregar(item_recibido.get_item(),indice)

func _drop_data(position: Vector2, data: Variant) -> void:
	if _can_drop_data(position,data):
		var item_recibido = data as ItemRect
		var item = item_recibido.pop()
		if item != null:
			contenedor.agregar(item,indice)

func _crear_preview() -> Control:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.size = size
	return preview
