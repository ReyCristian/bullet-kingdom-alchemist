extends Arma
class_name ArmaRango

@export var proyectil: PackedScene

func usar():
	if not esta_listo() or not nodo_instanciado or not proyectil:
		print("no esta listo")
		return

	var shot = proyectil.instantiate()
	shot.global_position = nodo_instanciado.global_position
	shot.rotation = nodo_instanciado.rotation
	nodo_instanciado.get_tree().current_scene.add_child(shot)

	super.usar()  # inicia cooldown

func procesar_fisica(_delta: float):
	if nodo_instanciado:
		nodo_instanciado.look_at(nodo_instanciado.get_global_mouse_position())
