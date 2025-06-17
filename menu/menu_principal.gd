extends Control
@onready var menu: AudioStreamPlayer2D = $Menu

var previous_scene: PackedScene


func _on_inicio_pressed() -> void: #inicio el juego
	#$Menu.stream_paused = true
	get_tree().change_scene_to_file("res://escenas/node_2d.tscn")  

func _on_salida_pressed() -> void:
	get_tree().quit()  # Cierro el juego

func _on_opciones_pressed() -> void:
	#$Menu.stream_paused = true
	get_tree().change_scene_to_file("res://menu/menu_opciones.tscn")  # Cargo el menú de opciones
