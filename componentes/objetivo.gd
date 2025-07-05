extends Resource
class_name Objetivo

var personaje: Personaje
var obstaculo: Obstaculo
var posicion: Vector2 = Vector2.INF
var direccion: Vector2 = Vector2.INF
var permanente: bool = true

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

func agregar_posicion(p:Vector2 ):
	posicion = p
	#personaje = null
	#obstaculo = null
	#direccion = Vector2.INF

func agregar_direccion(dir: Vector2):
	direccion = dir

func obtener_posicion() -> Vector2:
	if posicion != Vector2.INF:
		return posicion
	elif personaje != null:
		return personaje.global_position
	elif obstaculo != null:
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

func es_igual_a(otro: Objetivo) -> bool:
	# Comparación directa por personaje
	if personaje != null and otro.personaje != null:
		if personaje == otro.personaje:
			return true;

	# Comparación directa por obstáculo
	if obstaculo != null and otro.obstaculo != null:
		if obstaculo == otro.obstaculo:
			return true;

	# Comparación directa por posición
	if posicion != Vector2.INF and otro.posicion != Vector2.INF:
		if posicion == otro.posicion:
			return true;

	# Comparar si una posición está dentro del personaje del otro
	if personaje != null and otro.posicion != Vector2.INF:
		if personaje is CharacterBody2D and personaje.contiene_punto(otro.posicion):
			return true;

	if otro.personaje != null and posicion != Vector2.INF:
		if otro.personaje is CharacterBody2D and otro.personaje.contiene_punto(posicion):
			return true;

	return false;

func es_permanente():
	return permanente and obtener_posicion() != Vector2.INF;
