class_name Item
extends Resource

@export var nombre_personalizado: String = ""
var nombre: String :get = get_nombre, set = set_nombre
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun
@export var tipo:TipoItem
@export var atributos: Array[Atributo]
@export var nivel: int = 0;

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
	return tipo.nombre + " " + rareza_to_string(rareza,tipo.genero)

func set_nombre(value: String) -> void:
	nombre_personalizado = value

static func rareza_to_string(r: Rareza,genero:String="a") -> String:
	match r:
		Rareza.comun: return "Mundan"+genero
		Rareza.raro: return "Distint"+genero
		Rareza.muy_raro: return "Peculiar"
		Rareza.super_raro: return "Bendit"+genero
		Rareza.rarisimo: return "Unic"+genero
		_: return "Sin rareza"

static func color_por_rareza(r: Rareza) -> String:
	match r:
		Rareza.raro: return "green"
		Rareza.muy_raro: return "#2020ff"
		Rareza.super_raro: return "#9e49b7"
		Rareza.rarisimo: return "gold"
		_: return "white"

func borrar():
	get_rect().contenedor._items[get_rect().indice] = null;
	get_rect().borrar();

func descripcion() -> String:
	var texto := "[center][color=%s]%s[/color][/center]" % [color_por_rareza(rareza), get_nombre()]
	if nivel > 1:
		texto += "\nNivel " + str(nivel)
	texto += "\n[font_size=6]"  # achicamos los atributos
	for atributo in atributos:
		texto += "\n" + atributo.descripcion()
	texto += "[/font_size]"
	return texto
