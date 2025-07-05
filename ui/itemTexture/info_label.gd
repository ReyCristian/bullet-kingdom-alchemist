extends Label
class_name InfoLabel

func _init() -> void:
	var font: Font = load("res://ui/fuente/Mojang-Regular.ttf")
	add_theme_font_override("font", font)
	add_theme_font_size_override("font_size", 3)
	
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_outline_color", Color.BLACK)
	add_theme_constant_override("outline_size", 3)
