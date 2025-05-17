extends Control
class_name Equipamento

func _enter_tree():
	for nodo in get_tree().get_nodes_in_group("personaje"):
		print(nodo)
		if nodo is Personaje:
			$Contenedor_Armas.personaje = nodo
			$Contenedor_Armas._ready()
			$Contenedor_Armadura.personaje = nodo
			$Contenedor_Armadura._ready()
			break
