extends Ataque
class_name AtaqueAutomatico

var capa_objetivo: int = 0;
var area_conectada: Area2D = null;

func _init(_capa_objetivo: int) -> void:
	capa_objetivo = _capa_objetivo;
	
func _buscar_objetivos() -> Array[Objetivo]:
	var arma: Arma = personaje.obtener_arma(mano);
	if arma == null:
		return [];

	arma.set_capa_objetivo(capa_objetivo)
	var area: Area2D = arma.obtener_rango()
	if area == null:
		return [];

	var cuerpos: Array[Node2D] = area.get_overlapping_bodies();
	for cuerpo in cuerpos:
		if cuerpo is Personaje:
			var obj: Objetivo = Objetivo.new();
			obj.agregar_personaje(cuerpo);
			return [obj];

	return [];
