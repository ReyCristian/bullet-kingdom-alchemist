extends Equipable
class_name Armadura

static var tipos_validos = [
	TipoItem.Casco,
	TipoItem.Pechera,
	TipoItem.Botas
]

func obtener_slot() -> int:
	match tipo:
		TipoItem.Casco:
			return 0
		TipoItem.Pechera:
			return 1
		TipoItem.Botas:
			return 2
		_:
			return -1  # No es una armadura válida
