extends Resource
class_name Atributo

enum Tipo{
	DAÑO,DAÑO_PORCENTUAL,
	DEFENSA,DEFENSA_PORCENTUAL,
	VELOCIDAD,VELOCIDAD_ATAQUE,
	CRITICO,CRITICO_BONUS,
	RESISTENCIA_CRITICO,
	EVASION,RESISTENCIA_EMPUJE,
	ALCANCE_EXTRA,EMPUJE
}

const NombresTipo := {
	Tipo.DAÑO: "Daño",
	Tipo.DAÑO_PORCENTUAL: "Daño %",
	Tipo.DEFENSA: "Defensa",
	Tipo.DEFENSA_PORCENTUAL: "Defensa %",
	Tipo.VELOCIDAD: "Velocidad",
	Tipo.VELOCIDAD_ATAQUE: "Vel. Ataque",
	Tipo.CRITICO: "Crítico",
	Tipo.CRITICO_BONUS: "Bonus Crítico",
	Tipo.RESISTENCIA_CRITICO: "Bonus Crítico",
	Tipo.EVASION: "Evasión",
	Tipo.RESISTENCIA_EMPUJE: "Res. Empuje",
	Tipo.ALCANCE_EXTRA: "Alcance Extra",
	Tipo.EMPUJE: "Empuje"
}

@export var tipo:Tipo;
@export var valor:int;
@export var rareza:Item.Rareza;


static func crear(_valor:int, _rareza:Item.Rareza) -> Atributo:
	var atributo := Atributo.new()
	atributo.tipo = Tipo.values()[randi() % Tipo.size()]
	atributo.rareza = _rareza
	var multiplicador := 1
	match _rareza:
		Item.Rareza.comun:
			multiplicador = 1
		Item.Rareza.raro:
			multiplicador = 10
		Item.Rareza.muy_raro:
			multiplicador = 100
		Item.Rareza.super_raro:
			multiplicador = 500
		Item.Rareza.rarisimo:
			multiplicador = 1000

	atributo.valor = _valor * multiplicador
	return atributo

func descripcion() -> String:
	var color := Item.color_por_rareza(rareza)
	return "[color=%s]%s: %d[/color]" % [color, NombresTipo.get(tipo, "¿?"), valor]
	
static func sumar(a: Atributo, b: Atributo) -> Atributo:
	var nuevo := a.duplicate()
	if a.tipo != b.tipo:
		push_warning("Intentando sumar atributos de tipo distinto: %s vs %s" % [a.tipo, b.tipo])
		return nuevo
	nuevo.valor += b.valor
	if b.rareza > nuevo.rareza:
		nuevo.rareza = b.rareza
	return nuevo

static func agregar_en(diccionario: Dictionary, atributo: Atributo) -> void:
	var _tipo := atributo.tipo
	if diccionario.has(_tipo):
		diccionario[_tipo] = Atributo.sumar(diccionario[_tipo], atributo)
	else:
		diccionario[_tipo] = atributo.duplicate()

static func get_valor(diccionario: Dictionary, _tipo: Atributo.Tipo) -> int:
	var atributo: Atributo = diccionario.get(_tipo, null)
	return atributo.valor if atributo != null else 0
