extends Personaje
class_name Heroe

func morir():
	#print("reiniciando")
	Alquimia.limpiar_pools()
	#get_tree().reload_current_scene()
	get_tree().change_scene_to_file("res://menu/menu_derrota.tscn")
