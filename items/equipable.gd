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

var nodo_instanciado: Node = null  # guardamos la instancia del nodo de uso

func equipar(personaje: Node) -> void:
	if nodo_uso:
		nodo_instanciado = nodo_uso.instantiate()
		#nodo_instanciado.datos = self  # opcional: pasar el recurso
		personaje.add_child(nodo_instanciado)

func procesar_fisica(_delta: float):
	pass

func desequipar(_personaje: Node) -> void:
	if nodo_instanciado:
		# Si estás usando pooling
		if nodo_instanciado.has_method("reset"):
			nodo_instanciado.reset()
			#ObjectPool.devolver(nodo_instanciado)
		else:
			nodo_instanciado.queue_free()
		nodo_instanciado = null
