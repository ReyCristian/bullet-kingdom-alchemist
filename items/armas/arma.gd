extends Equipable
class_name Arma

@export var daño_base: int = 0
@export var cooldown: float = 1.0
var cooldown_timer: Timer

static var tipos_validos = [
	TipoItem.Espada,
	TipoItem.Hacha,
	TipoItem.Lanza,
	TipoItem.Arco,
	TipoItem.Daga_arrojadiza,
	TipoItem.Hacha_arrojadiza,
	TipoItem.Varita,
	TipoItem.Bumerang
]

func _init():
	#OJO aunq lo creo aca, los valores del recurso no estan aun asi q el cooldown hay q volverlo a poner al equipar
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	cooldown_timer.timeout.connect(_cooldown_terminado)

func usar():
	if not esta_listo():
		return
	cooldown_timer.start()

func esta_listo() -> bool:
	return cooldown_timer and cooldown_timer.is_stopped()

func _cooldown_terminado():
	pass  # para override o efectos visuales
	
func equipar(personaje: Node) -> void:
	super.equipar(personaje)
	
	#recargo estos valores porque cambiaron
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	
	if cooldown_timer and not cooldown_timer.get_parent():
		nodo_instanciado.add_child(cooldown_timer)
