extends Personaje
class_name Heroe

func morir():
	print("reiniciando")
	Alquimia.limpiar_pools()
	get_tree().reload_current_scene()
