extends Personaje
class_name Heroe

func morir():
	print("reiniciando")
	Alquimia.limpiar_pools()
	get_tree().reload_current_scene()

func _ready() -> void:
	vida = 1000
	super._ready()
