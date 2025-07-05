extends Arma
class_name ArmaRango



func usar():
	if not esta_listo() or \
		not nodo_equipado or \
		not tipo.proyectil or \
		not personaje:
		#TODO print("no esta listo")
		return

	var shot:Proyectil = tipo.proyectil.instantiate()
	shot.atributos = personaje.get_atributos()
	shot.daño_base = daño_base
	nodo_equipado.get_tree().current_scene.add_child(shot)
	shot.rotation = nodo_equipado.rotation
	shot.global_position = nodo_equipado.global_position
	var sprite := personaje.get_node_or_null("Sprite2D")
	if sprite:
		shot.modulate = sprite.modulate

	super.usar()  # inicia cooldown

func apuntar(objetivo:Objetivo)->bool:
	if nodo_equipado and objetivo:
		nodo_equipado.look_at(objetivo.obtener_posicion())
		return true
	return false
