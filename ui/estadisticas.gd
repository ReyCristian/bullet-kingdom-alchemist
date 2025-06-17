extends Control

var personaje:Personaje;
@onready var label = $Atributos/RichTextLabel

func _enter_tree():
	for nodo in get_tree().get_nodes_in_group("personaje"):
		if nodo is Personaje:
			personaje = nodo
			break

func _al_mostrar():
	if personaje:
		label.text = personaje.descripcion()
		
