extends Resource
class_name Atributo

enum Tipo{
	DAÑO,DAÑO_PORCENTUAL,
	DEFENSA,DEFENSA_PORCENTUAL,
	VELOCIDAD,VELOCIDAD_ATAQUE,
	CRITICO,CRITICO_BONUS,
	EVASION,
	#EMPUJE,RESISTENCIA_EMPUJE,
	ALCANCE_EXTRA
}

const NombresTipo := {
	Tipo.DAÑO: "Ataque",
	Tipo.DAÑO_PORCENTUAL: "Atq. %",
	Tipo.DEFENSA: "Defensa",
	Tipo.DEFENSA_PORCENTUAL: "Defensa %",
	Tipo.VELOCIDAD: "Vel. Mov.",
	Tipo.VELOCIDAD_ATAQUE: "Vel. Atq",
	Tipo.CRITICO: "Prob. Crít.",
	Tipo.CRITICO_BONUS: "Atq. Crít.",
	Tipo.EVASION: "Evasión",
	#Tipo.RESISTENCIA_EMPUJE: "Res. Empuje",
	#Tipo.EMPUJE: "Empuje",
	Tipo.ALCANCE_EXTRA: "Rango Extra"
}

const InicialesTipo := {
	Tipo.DAÑO: "A",
	Tipo.DAÑO_PORCENTUAL: "A%",
	Tipo.DEFENSA: "D",
	Tipo.DEFENSA_PORCENTUAL: "D%",
	Tipo.VELOCIDAD: "VM",
	Tipo.VELOCIDAD_ATAQUE: "VA",
	Tipo.CRITICO: "C",
	Tipo.CRITICO_BONUS: "AC",
	Tipo.EVASION: "E",
	#Tipo.RESISTENCIA_EMPUJE: "Res. Empuje",
	#Tipo.EMPUJE: "Empuje",
	Tipo.ALCANCE_EXTRA: "R"
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

func descripcion(valor_base: float = 0.0) -> String:
	var color := Item.color_por_rareza(rareza)
	return "[color=%s]%s: %s[/color]" % [color, get_nombre(), calcular_descrip(valor_base)]

func get_nombre() -> String:
	return NombresTipo.get(tipo, "¿?")

func calcular(valor_base: float = 0.0) -> float:
	match tipo:
		Tipo.VELOCIDAD:
			return 1.0 + log(1.0 + valor / 100.0)
		Tipo.VELOCIDAD_ATAQUE:
			return 1.0 / (1.0 + log(1.0 + valor / 100.0))
		Tipo.DAÑO_PORCENTUAL, Tipo.DEFENSA_PORCENTUAL:
			return valor_base * (valor / 100.0)
		Tipo.CRITICO,Tipo.EVASION:
			return 1.0 - (1.0 / (1.0 + log(1.0 + valor / 100.0)))
		Tipo.CRITICO_BONUS:
			return (1.0 + valor / 100.0)
		Tipo.ALCANCE_EXTRA:
			return 1.0 + log(1.0 + valor / 1000.0)
		_:
			return float(valor)

func calcular_descrip(valor_base: float = 0.0) -> String:
	match tipo:
		Tipo.VELOCIDAD,Tipo.EVASION,Tipo.CRITICO,Tipo.CRITICO_BONUS,Tipo.ALCANCE_EXTRA:
			return "+%d (%.0f%%)" % [valor,(calcular() * 100.0)]
		Tipo.VELOCIDAD_ATAQUE:
			return "+%d (-%.0f%% de CD)" % [valor,((1-calcular()) * 100.0)]
		Tipo.DAÑO_PORCENTUAL, Tipo.DEFENSA_PORCENTUAL:
			return "%d%% (+%.0f)" % [valor,calcular(valor_base)]
		_:
			return "%d" % valor

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

static func get_modificador(diccionario: Dictionary, _tipo: Atributo.Tipo) -> float:
	var atributo: Atributo = diccionario.get(_tipo, null)
	var valor_base := get_base(diccionario,_tipo)
	
	if atributo == null:
		match _tipo:
			Tipo.VELOCIDAD, Tipo.VELOCIDAD_ATAQUE,Tipo.ALCANCE_EXTRA,Tipo.CRITICO_BONUS:
				return 1.0
			_:
				return 0.0

	return atributo.calcular(valor_base)

static func get_base(diccionario: Dictionary, _tipo: Atributo.Tipo) -> float:
	match _tipo:
		Tipo.DAÑO_PORCENTUAL:
			return get_valor(diccionario,Tipo.DAÑO)
		Tipo.DEFENSA_PORCENTUAL:
			return get_valor(diccionario,Tipo.DEFENSA)
		_:
			return 0.0

static func get_descripcion(diccionario: Dictionary) -> String:
	var texto = "";
	var keys = diccionario.keys()
	keys.sort()
	for key in keys:
		var atributo :Atributo= diccionario[key]
		var valor_base = get_base(diccionario,key)
		texto += "\n"+ atributo.descripcion(valor_base)
	return texto

static func get_iniciales(lista:Array)-> String:
	if lista.is_empty():
		return "";
	lista.sort_custom(func(a:Atributo, b:Atributo):	return a.valor > b.valor)
	return InicialesTipo.get(lista[0].tipo, "¿?") + " "
