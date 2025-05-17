extends TextureRect
class_name ItemRect

@export var icono_default: ItemIcon = ItemIcon.new()
@export var contenedor: Contenedor
@export var indice: int = -1

@export var inmobil: bool = false

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
	if inmobil:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# el drag se inicia solo, no necesitas hacer nada acá
		pass

func _get_drag_data(_position: Vector2):
	if inmobil:
		return null
	var preview = _crear_preview()
	set_drag_preview(preview)
	return self

func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	if not data is ItemRect:
		return false;
	var item_recibido = data as ItemRect
	return contenedor.puede_agregar(item_recibido.get_item(),indice)

func _drop_data(_position: Vector2, data: Variant) -> void:
	if _can_drop_data(_position,data):
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
	preview.modulate = Color(1, 1, 1, 0.5)
	return preview
	
func mover_a_slot(nuevo_slot: Control, pos_objetivo: Vector2) -> void:
	var pos_global = global_position
	if get_parent():
		get_parent().remove_child(self)
	nuevo_slot.add_child(self)
	set_global_position(pos_global)
	var tween = create_tween()
	tween.tween_property(self, "position", pos_objetivo, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
