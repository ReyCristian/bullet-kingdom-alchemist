extends Item
class_name Equipable

@export var daño: int = 0
@export var daño_porcentual: float = 0.0
@export var defensa: int = 0
@export var defensa_porcentual: float = 0.0
@export var velocidad: float = 0.0
@export var velocidad_ataque: float = 0.0
@export var critico: float = 0.0
@export var critico_bonus: float = 0.0
@export var evasion: float = 0.0
@export var resistencia_empuje: float = 0.0
@export var alcance_extra: int = 0


var nodo_equipado: Node = null  # guardamos la instancia del nodo de uso

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
