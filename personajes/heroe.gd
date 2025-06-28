extends Personaje
class_name Heroe

func morir():
	#print("reiniciando")
	Alquimia.limpiar_pools()
	#get_tree().reload_current_scene()
	call_deferred("cambiar_a_menu_derrota")

func cambiar_a_menu_derrota():
	get_tree().change_scene_to_file("res://menu/menu_derrota.tscn")

func _ready() -> void:
	vida = 100000
	super._ready()
