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
		
	aplicar_atributos()
	get_cooldown_timer().start()

func aplicar_atributos():
	var modificador_cooldown := Atributo.get_modificador(personaje.get_atributos(), Atributo.Tipo.VELOCIDAD_ATAQUE)
	get_cooldown_timer().wait_time = cooldown * modificador_cooldown
	
	if nodo_equipado:
		var rango: Area2D = nodo_equipado.get_node_or_null("Rango")
		var modificador_rango := Atributo.get_modificador(personaje.get_atributos(), Atributo.Tipo.ALCANCE_EXTRA)
		rango.scale = Vector2.ONE * modificador_rango
	

func esta_listo() -> bool:
	return get_cooldown_timer() and get_cooldown_timer().is_stopped()

func _cooldown_terminado():
	pass  # para override o efectos visuales
	
func equipar(_personaje: Node) -> void:
	super.equipar(_personaje)
	
	# Detectar en qué mano estoy
	for m in Personaje.Mano.values():
		if _personaje.obtener_arma(m) == self:
			mano = m
			break
	
	#recargo estos valores porque cambiaron
	get_cooldown_timer().one_shot = true
	aplicar_atributos()
	
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
	#print("Se cambio capa a %d" % capa_objetivo)
	var area: Area2D = obtener_rango()
	if area != null:
		area.collision_mask = capa_objetivo;

func descripcion() -> String:
	var texto = encabezado_descripcion()
	texto += "\n" + daño_descripcion()
	texto += "\n" + atributos_descripcion()
	return texto

func daño_descripcion() -> String:
	var texto = "[font_size=8]"
	texto += "Daño base: %s" % daño_base 
	texto += "[/font_size]"
	return texto
