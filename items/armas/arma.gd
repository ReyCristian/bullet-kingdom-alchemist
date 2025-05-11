extends Equipable
class_name Arma

@export var daño_base: int = 0
@export var cooldown: float = 1.0
@export var espera: float = 0.0

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

func usar():
	print("¡Usando arma!")

func esta_listo() -> bool:
	return espera <= 0
