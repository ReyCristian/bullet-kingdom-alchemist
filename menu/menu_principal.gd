extends Control
@onready var menu: AudioStreamPlayer2D = $VBoxContainer/Menu

var previous_scene: PackedScene

func _ready() -> void:
	Alquimia.limpiar_pools()


func _on_inicio_pressed() -> void: #inicio el juego
	$VBoxContainer/Menu.stream_paused = true
	get_tree().change_scene_to_file("res://escenas/node_2d.tscn")  

func _on_salida_pressed() -> void:
	get_tree().quit()  # Cierro el juego

func _on_opciones_pressed() -> void:
	$VBoxContainer/Menu.stream_paused = true
	get_tree().change_scene_to_file("res://menu/menu_opciones.tscn")  # Cargo el menú de opciones
