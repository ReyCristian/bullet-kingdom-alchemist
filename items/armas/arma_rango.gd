extends Arma
class_name ArmaRango



func usar():
	if not esta_listo() or not nodo_equipado or not tipo.proyectil:
		#TODO print("no esta listo")
		return

	var shot = tipo.proyectil.instantiate()
	shot.global_position = nodo_equipado.global_position
	shot.rotation = nodo_equipado.rotation
	nodo_equipado.get_tree().current_scene.add_child(shot)

	super.usar()  # inicia cooldown

func apuntar(objetivo:Objetivo)->bool:
	if nodo_equipado and objetivo:
		nodo_equipado.look_at(objetivo.obtener_posicion())
		return true
	return false
