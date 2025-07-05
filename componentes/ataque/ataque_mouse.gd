extends Ataque
class_name AtaqueMouse

func _buscar_objetivos() -> Array[Objetivo]:
	var arma: Arma = personaje.obtener_arma(mano);
	if arma != null and arma.nodo_equipado != null:
		var obj: Objetivo = Objetivo.new();
		obj.agregar_posicion(arma.nodo_equipado.get_global_mouse_position());
		obj.permanente = false;
		return [obj];
	return [];


func usar(arma: Arma):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		super.usar(arma);
