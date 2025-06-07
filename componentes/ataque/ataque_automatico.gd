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

	var area: Area2D = arma.nodo_equipado.get_node_or_null("Rango");
	if area == null:
		return [];

	area.collision_mask = capa_objetivo;

	var cuerpos: Array[Node2D] = area.get_overlapping_bodies();
	for cuerpo in cuerpos:
		if cuerpo is Personaje:
			var obj: Objetivo = Objetivo.new();
			obj.agregar_personaje(cuerpo);
			return [obj];

	return [];
