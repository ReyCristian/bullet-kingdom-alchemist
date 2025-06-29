extends TextureRect


func _ready() -> void:
	StatsTooltip.mostrarDerrota($Marker2D.position)
	$Estadisticas.text = StatsTooltip.estadisticas
	$Puntaje.text = "Enemigos eliminados:" + StatsTooltip.puntaje



func  _on_salir_pressed() -> void:
	get_tree().quit()  # Cierro el juego


func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/node_2d.tscn")
