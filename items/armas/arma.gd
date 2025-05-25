extends Equipable
class_name Arma

@export var daño_base: int = 1
@export var cooldown: float = 0.3
var cooldown_timer: Timer

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
	
	#recargo estos valores porque cambiaron
	get_cooldown_timer().one_shot = true
	get_cooldown_timer().wait_time = cooldown
	
	if get_cooldown_timer() and not get_cooldown_timer().get_parent():
		nodo_equipado.add_child(get_cooldown_timer())

func get_cooldown_timer() -> Timer:
	if cooldown_timer == null:
		cooldown_timer = Timer.new()
		cooldown_timer.one_shot = true
		cooldown_timer.wait_time = cooldown
		cooldown_timer.timeout.connect(_cooldown_terminado)
	if cooldown_timer.get_parent() == null:
		nodo_equipado.add_child(cooldown_timer)
	return cooldown_timer
