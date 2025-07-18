extends Equipable
class_name Armadura

static var tipos_validos = [
	TipoItem.Grupo.Casco,
	TipoItem.Grupo.Pechera,
	TipoItem.Grupo.Botas
]

func equipar(_personaje: Node) -> void:
	super.equipar(_personaje)
	ocultar_icono()

func ocultar_icono():
	nodo_equipado.visible = false

func obtener_slot() -> int:
	match tipo.grupo:
		TipoItem.Grupo.Casco:
			return 0
		TipoItem.Grupo.Pechera:
			return 1
		TipoItem.Grupo.Botas:
			return 2
		_:
			return -1  # No es una armadura válida
