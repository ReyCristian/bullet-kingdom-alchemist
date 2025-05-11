extends TextureRect
class_name ItemIcon

@export var icono_vacio: Texture2D = preload("res://icon.svg")

	
func _ready():
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reset_icono()
	custom_minimum_size = Vector2(16, 16)

func set_icono(texture_nueva: Texture2D) -> void:
	texture = texture_nueva

func reset_icono() -> void:
	texture = icono_vacio
