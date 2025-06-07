extends Personaje
class_name Heroe

func morir():
	print("reiniciando")
	var escena_actual = get_tree().current_scene
	Alquimia.limpiar_pools()
	get_tree().reload_current_scene()
