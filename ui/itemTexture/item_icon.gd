extends Resource
class_name ItemIcon

@export var icono: Texture2D = preload("res://icon.svg")

func _init() -> void:
	icono = get_icono()

func set_icono(texture_nueva: Texture2D) -> void:
	icono = texture_nueva
	
func get_icono() -> Texture2D:
	return icono;
