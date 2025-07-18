extends Control

#@onready var music_volume_slider = $musica
@onready var master_volume_slider = $VBoxContainer/master
#@onready var menu: AudioStreamPlayer2D = $menu


var esperando_tecla = false
var accion_a_reasignar = ""

func _ready():
	## Inicializar sliders con el volumen actual de los buses de audio
	var sonido_master= AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var slider_master=lerp(0,100,(sonido_master+80)/80)
	$VBoxContainer/master.value= slider_master
  
	var sonido_musica= AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica"))
	var slider_musica=lerp(0,100,(sonido_musica+80)/80)
	$VBoxContainer/musica.value=slider_musica
	var sonido_efecto= AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Efecto"))
	var slider_efecto=lerp(0,100,(sonido_efecto+80)/80)
	$VBoxContainer/Efecto.value=slider_efecto
	if get_tree().current_scene.name=="MenuOpciones":
		$VBoxContainer/menu.play()



func _on_master_value_changed(value: float) -> void:
	var db_value = lerp(-80, 0, value/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)

func _on_music_value_changed(value: float) -> void:
	var db_value = lerp(-80,0,value/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"),db_value)

func _on_efecto_value_changed(value: float) -> void:
	var db_value =lerp(-80,0,value/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efecto"),db_value)



func _on_volver_pressed() -> void:
	if get_tree().current_scene.name=="MenuOpciones":
		get_tree().change_scene_to_file("res://menu/menu_principal.tscn")  # Volver al menú principal
	else:
		get_tree().get_first_node_in_group("menu_pausa").visible= true
		$".".visible=false
