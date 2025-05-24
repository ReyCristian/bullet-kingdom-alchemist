class_name Item
extends Resource

@export var nombre: String = "Item sin nombre"
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun
@export var tipo:TipoItem

var _rect: ItemRect

enum Rareza {
	comun,
	raro,
	muy_raro,
	super_raro,
	rarisimo
}

func get_rect() -> ItemRect:
	if not _rect:
		_rect = ItemRect.new(tipo.icono)
	_rect.name = nombre
	return _rect
