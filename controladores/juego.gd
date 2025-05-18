extends Node2D
class_name ControladorJuego



func _on_child_entered_tree(node: Node) -> void:
	if node is Enemigo:
		node.muerte.connect(muerte_enemigo.bind(node))
	pass # Replace with function body.


func muerte_enemigo(e: Node):
	$ContenedorItemsSueltos.soltar(load("res://items/creados/chapita.tres").duplicate(),e.global_position)


func tomar_item(item: Item) -> void:
	$Deidad.tomar_item(item)
	pass
