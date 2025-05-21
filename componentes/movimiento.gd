extends Resource
class_name Movimiento

@export var destino: Objetivo
@export var teclas: Array[String] = ["ui_left", "ui_right", "ui_up", "ui_down"]

func mover(personaje: CharacterBody2D, _delta: float) -> void:
	var input_vector = Input.get_vector(teclas[0], teclas[1], teclas[2], teclas[3])

	if input_vector == Vector2.ZERO and destino:
		var origen = personaje.global_position
		input_vector = destino.obtener_direccion(origen)

	personaje.velocity = input_vector * personaje.get("speed")
	personaje.move_and_slide()
