class_name Item
extends Resource

@export var icono: ItemIcon
@export var tipo: TipoItem
@export var nombre: String = "Item sin nombre"
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun

var _rect: ItemRect

enum Rareza {
	comun,
	raro,
	muy_raro,
	super_raro,
	rarisimo
}

enum TipoItem {
	Espada,
	Hacha,
	Lanza,
	Arco,
	Daga_arrojadiza,
	Hacha_arrojadiza,
	Escudo,
	Varita,
	Bumerang,
	Casco,
	Pechera,
	Botas,
	Chatarra,
	Maderita,
	Cuero
}

func get_rect() -> ItemRect:
	if not _rect:
		_rect = ItemRect.new(icono)
	_rect.name = nombre
	return _rect
