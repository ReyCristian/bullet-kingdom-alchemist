extends Resource
class_name Atributo

enum Tipo{
	DAÑO,DAÑO_PORCENTUAL,
	DEFENSA,DEFENSA_PORCENTUAL,
	VELOCIDAD,VELOCIDAD_ATAQUE,
	CRITICO,CRITICO_BONUS,
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
	Tipo.EVASION: "Evasión",
	Tipo.RESISTENCIA_EMPUJE: "Res. Empuje",
	Tipo.ALCANCE_EXTRA: "Alcance Extra",
	Tipo.EMPUJE: "Empuje"
}

@export var tipo:Tipo;
@export var valor:int;
@export var rareza:Item.Rareza;


static func crear(valor:int, rareza:Item.Rareza) -> Atributo:
	var atributo := Atributo.new()
	atributo.tipo = Tipo.values()[randi() % Tipo.size()]
	atributo.rareza = rareza
	var multiplicador := 1
	match rareza:
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

	atributo.valor = valor * multiplicador
	return atributo

func descripcion() -> String:
	var color := Item.color_por_rareza(rareza)
	return "[color=%s]%s: %d[/color]" % [color, NombresTipo.get(tipo, "¿?"), valor]
