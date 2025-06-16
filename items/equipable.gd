extends Item
class_name Equipable

var nodo_equipado: Node2D = null  # guardamos la instancia del nodo de uso

func equipar(personaje: Node) -> void:
	if tipo.nodo_uso:
		nodo_equipado = tipo.nodo_uso.instantiate()
		#nodo_equipado.datos = self  #TODO opcional: pasar el recurso
		personaje.add_child(nodo_equipado)

func procesar_fisica(_delta: float):
	pass

func desequipar(_personaje: Node) -> void:
	if nodo_equipado:
		# Si estás usando pooling
		if nodo_equipado.has_method("reset"):
			nodo_equipado.reset()
			#ObjectPool.devolver(nodo_equipado)
		else:
			nodo_equipado.queue_free()
		nodo_equipado = null
