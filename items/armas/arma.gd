extends Equipable
class_name Arma

@export var daño_base: int = 1
@export var cooldown: float = 1
var cooldown_timer: Timer
var mano: Personaje.Mano

static var tipos_validos = [
	TipoItem.Grupo.Espada,
	TipoItem.Grupo.Hacha,
	TipoItem.Grupo.Lanza,
	TipoItem.Grupo.Arco,
	TipoItem.Grupo.Daga_arrojadiza,
	TipoItem.Grupo.Hacha_arrojadiza,
	TipoItem.Grupo.Varita,
	TipoItem.Grupo.Bumerang
]

func usar():
	if not esta_listo():
		return
	get_cooldown_timer().start()

func esta_listo() -> bool:
	return get_cooldown_timer() and get_cooldown_timer().is_stopped()

func _cooldown_terminado():
	pass  # para override o efectos visuales
	
func equipar(personaje: Node) -> void:
	super.equipar(personaje)
	
	# Detectar en qué mano estoy
	for m in Personaje.Mano.values():
		if personaje.obtener_arma(m) == self:
			mano = m
			break
	
	#recargo estos valores porque cambiaron
	get_cooldown_timer().one_shot = true
	get_cooldown_timer().wait_time = cooldown
	
	cambiar_icono()

func get_cooldown_timer() -> Timer:
	if cooldown_timer == null:
		cooldown_timer = Timer.new()
		cooldown_timer.one_shot = true
		cooldown_timer.wait_time = cooldown
		cooldown_timer.timeout.connect(_cooldown_terminado)
	if cooldown_timer.get_parent() == null:
		nodo_equipado.add_child(cooldown_timer)
	return cooldown_timer

func apuntar(_objetivo:Objetivo)->bool:
	return false

func obtener_rango():
	if nodo_equipado:
		return nodo_equipado.get_node_or_null("Rango");
	return null;

func procesar_fisica(_delta: float) -> void:
	if nodo_equipado:
		var direccion := 1.0
		if mano == Personaje.Mano.IZQUIERDA:
			direccion = -1.0
		
		nodo_equipado.rotation += direccion * PI * _delta
		nodo_equipado.rotation = fmod(nodo_equipado.rotation, TAU)

func cambiar_icono():
	var sprite: Sprite2D = nodo_equipado.get_node_or_null("Sprite2D")
	sprite.texture = tipo.icono.get_icono()
	sprite.scale = Vector2.ONE

func set_capa_objetivo(capa_objetivo:int):
	var area: Area2D = obtener_rango()
	if area != null:
		area.collision_mask = capa_objetivo;
