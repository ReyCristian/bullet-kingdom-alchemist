extends Control
class_name Equipamento

func _enter_tree():
	for nodo in get_tree().get_nodes_in_group("personaje"):
		if nodo is Personaje:
			$Contenedor_Armas.personaje = nodo
			$Contenedor_Armadura.personaje = nodo
			break
