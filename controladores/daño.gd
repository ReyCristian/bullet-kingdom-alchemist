extends Node
class_name Daño

var daño_base: float
var esCritico: bool = false
var esFallo: bool = false
var calculado: bool = false
var daño_total: float = 0

var _atributos_atacante: Dictionary = {}
var _atributos_defendente: Dictionary = {}

var atributos_atacante: Dictionary:
	get: return _atributos_atacante
	set(value):
		_atributos_atacante = value
		calculado = false

var atributos_defendente: Dictionary:
	get: return _atributos_defendente
	set(value):
		_atributos_defendente = value
		calculado = false

func _init(_daño_base: float) -> void:
	daño_base = _daño_base

func calcular() -> float:
	if not calculado:
		evaluar_critico()
		
		daño_total = 0;
		
		if (not evaluar_fallo()):
		
			daño_total += daño_base + Atributo.get_valor(atributos_atacante, Atributo.Tipo.DAÑO)
			daño_total += Atributo.get_modificador(atributos_atacante, Atributo.Tipo.DAÑO_PORCENTUAL)

			daño_total -= Atributo.get_valor(atributos_defendente, Atributo.Tipo.DEFENSA)
			daño_total -= Atributo.get_modificador(atributos_defendente, Atributo.Tipo.DEFENSA_PORCENTUAL)

			if esCritico:
				var crit_bonus: float = Atributo.get_modificador(atributos_atacante, Atributo.Tipo.CRITICO_BONUS)
				daño_total *= crit_bonus
			daño_total = max(0, daño_total)
		
		calculado = true

	return daño_total

func evaluar_critico() -> bool:
	var chance: float = Atributo.get_modificador(atributos_atacante, Atributo.Tipo.CRITICO)
	esCritico = randf() <= chance
	return esCritico
	
func evaluar_fallo() -> bool:
	var chance: float = Atributo.get_modificador(atributos_defendente, Atributo.Tipo.EVASION)
	esFallo = randf() <= chance
	return esFallo

func _to_string() -> String:
	calcular()
	return formato_si(daño_total) if not esFallo else "sqvo";


static func formato_si(numero: float) -> String:
	var unidades: Array[String] = ["", "k", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q"]
	var valor: float = abs(numero)
	var signo: String = "-" if numero < 0 else ""
	var indice: int = 0

	while valor >= 1000.0 and indice < unidades.size() - 1:
		valor /= 1000.0
		indice += 1

	if valor >= 100.0:
		return "%s%d%s" % [signo, int(valor), unidades[indice]]
	elif valor >= 10.0:
		return "%s%.1f%s" % [signo, valor, unidades[indice]]
	else:
		return "%s%.2f%s" % [signo, valor, unidades[indice]]
