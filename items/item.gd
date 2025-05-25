class_name Item
extends Resource

@export var nombre_personalizado: String = ""
var nombre: String :get = get_nombre, set = set_nombre
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun
@export var tipo:TipoItem

var _rect: ItemRect :set = _set_rect 

enum Rareza {
	comun,
	raro,
	muy_raro,
	super_raro,
	rarisimo
}

func _init(t: TipoItem=null, r: ItemRect=null):
	if t:
		tipo = t
	if r:
		_rect = r

func get_rect() -> ItemRect:
	_rect.name = nombre
	return _rect

func _set_rect(value: ItemRect) -> void:
	if _rect == null:
		_rect = value
	else:
		push_error("Intento de sobrescribir el rect de un Item ya existente.")

func get_nombre() -> String:
	if nombre_personalizado != "":
		return nombre_personalizado
	return tipo.nombre + "   " + rareza_to_string(rareza)

func set_nombre(value: String) -> void:
	nombre_personalizado = value

func rareza_to_string(r: Item.Rareza) -> String:
	match r:
		Item.Rareza.comun: return "Común"
		Item.Rareza.raro: return "Raro"
		Item.Rareza.muy_raro: return "Muy Raro"
		Item.Rareza.super_raro: return "Super Raro"
		_: return "Sin rareza"

func borrar():
	get_rect().contenedor._items[get_rect().indice] = null;
	get_rect().borrar();
