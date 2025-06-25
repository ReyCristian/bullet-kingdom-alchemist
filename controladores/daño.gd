extends Node
class_name Daño

var daño_base: int
var esCritico: bool = false
var esFallo: bool = false
var calculado: bool = false
var daño_total: int = 0

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

func _init(_daño_base: int) -> void:
	daño_base = _daño_base

func calcular() -> int:
	if not calculado:
		evaluar_critico()
		
		daño_total = 0;
		
		if (not evaluar_fallo()):
		
			daño_total += daño_base + Atributo.get_valor(atributos_atacante, Atributo.Tipo.DAÑO)
			daño_total += Atributo.get_modificador(atributos_atacante, Atributo.Tipo.DAÑO_PORCENTUAL)

			daño_total -= Atributo.get_valor(atributos_defendente, Atributo.Tipo.DEFENSA)
			daño_total -= Atributo.get_modificador(atributos_defendente, Atributo.Tipo.DEFENSA_PORCENTUAL)

			if esCritico:
				var crit_bonus = Atributo.get_modificador(atributos_atacante, Atributo.Tipo.CRITICO_BONUS)
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


static func formato_si(numero: int) -> String:
	var unidades: Array[String] = ["", "k", "M", "G", "T", "P", "E"]  # hasta exa
	var valor: float = float(numero)
	var indice: int = 0
	
	while valor >= 1000.0 and indice < unidades.size() - 1:
		valor /= 1000.0
		indice += 1
	
	if valor >= 100.0:
		return "%d%s" % [int(valor), unidades[indice]]
	elif valor >= 10.0:
		return "%.1f%s" % [valor, unidades[indice]]
	else:
		return "%.2f%s" % [valor, unidades[indice]]
