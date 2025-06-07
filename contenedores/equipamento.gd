extends Control
class_name Equipamento

@onready var contenedor_armas = $Contenedor_Armas;
@onready var contenedor_armadura = $Contenedor_Armadura;

func _enter_tree():
	for nodo in get_tree().get_nodes_in_group("personaje"):
		if nodo is Personaje:
			$Contenedor_Armas.personaje = nodo
			$Contenedor_Armadura.personaje = nodo
			break
		
