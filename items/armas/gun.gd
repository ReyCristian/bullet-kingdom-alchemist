extends Arma
class_name Gun

const bullet = preload("res://items/armas/proyectiles/bullet.tscn")

func usar():
	if not esta_listo() or not nodo_instanciado:
		return
	var shot = bullet.instantiate()
	shot.global_position = nodo_instanciado.global_position
	shot.rotation = nodo_instanciado.rotation
	nodo_instanciado.get_tree().current_scene.add_child(shot)
	#espera = cooldown

func procesar_fisica(delta: float):
	if nodo_instanciado:
		nodo_instanciado.look_at(nodo_instanciado.get_global_mouse_position())
