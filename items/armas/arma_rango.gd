extends Arma
class_name ArmaRango



func usar():
	if not esta_listo() or not nodo_equipado or not tipo.proyectil:
		print("no esta listo")
		return

	var shot = tipo.proyectil.instantiate()
	shot.global_position = nodo_equipado.global_position
	shot.rotation = nodo_equipado.rotation
	nodo_equipado.get_tree().current_scene.add_child(shot)

	super.usar()  # inicia cooldown

func procesar_fisica(_delta: float):
	if nodo_equipado:
		nodo_equipado.look_at(nodo_equipado.get_global_mouse_position())
