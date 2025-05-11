extends Resource
class_name Objetivo

var personaje: Personaje
var obstaculo: Obstaculo
var posicion: Vector2 = Vector2.INF
var direccion: Vector2 = Vector2.INF

func agregar_personaje(p: Personaje):
	personaje = p
	#posicion = Vector2.INF
	#obstaculo = null
	#direccion = Vector2.INF

func agregar_obstaculo(o: Obstaculo):
	obstaculo = o
	#posicion = Vector2.INF
	#personaje = null
	#direccion = Vector2.INF

func agregar_posicion(x: float, y: float):
	posicion = Vector2(x, y)
	#personaje = null
	#obstaculo = null
	#direccion = Vector2.INF

func agregar_direccion(dir: Vector2):
	direccion = dir

func obtener_posicion() -> Vector2:
	if posicion != Vector2.INF:
		return posicion
	elif personaje:
		return personaje.global_position
	elif obstaculo:
		return obstaculo.global_position
	else:
		return Vector2.INF

func obtener_direccion(desde: Vector2) -> Vector2:
	if direccion != Vector2.INF:
		return direccion.normalized()

	var destino = obtener_posicion()
	if destino == Vector2.INF:
		return Vector2.ZERO

	return (destino - desde).normalized()
