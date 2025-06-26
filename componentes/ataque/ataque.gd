extends Resource
class_name Ataque

var personaje: Personaje = null;
var mano: Personaje.Mano;
var objetivo: Objetivo

func equipar(_personaje: Personaje, _mano: Personaje.Mano) -> void:
	personaje = _personaje;
	mano = _mano;

func desequipar() -> void:
	personaje = null;

func procesar_fisica(_delta: float) -> void:
	if personaje == null:
		return;
	
	var arma: Arma = personaje.obtener_arma(mano);
	if arma == null:
		return;
	
	if not objetivo or not objetivo.es_permanente():
		objetivo = _buscar_objetivo_propio();
	
	if arma.apuntar(objetivo):
		usar(arma);

# Método abstracto: las subclases deben sobreescribirlo para proporcionar un objetivo/s válido.
func _buscar_objetivos() -> Array[Objetivo]:
	return [];

func usar(arma: Arma):
	arma.usar()

func _buscar_objetivo_propio() -> Objetivo:
	var candidatos: Array[Objetivo] = _buscar_objetivos();
	if candidatos.is_empty():
		return null;
	#lo saco aca porque no tengo tiempo de revisar que el objetivo del otro esta por morir
	return candidatos[0]
	var otros: Array[Ataque] = personaje.obtener_otros_ataques(self);

	for candidato in candidatos:
		var en_uso: bool = false;
		for otro in otros:
			if otro.objetivo != null and otro.objetivo.es_igual_a(candidato):
				en_uso = true;
				break;
		if not en_uso:
			return candidato;

	return null;
