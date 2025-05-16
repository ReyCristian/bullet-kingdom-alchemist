extends TextureRect
class_name ItemRect

@export var icono_default: ItemIcon = ItemIcon.new()

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
