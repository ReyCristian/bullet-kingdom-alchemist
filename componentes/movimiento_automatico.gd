class_name MovimientoAutomatico
extends Movimiento

const SPEED = 150
var direction = Vector2(1, 0)  # Dirección inicial
var rng = RandomNumberGenerator.new()

func _init() -> void:
	rng.randomize()

func mover(personaje: CharacterBody2D, _delta: float) -> void:
	personaje.velocity = direction * SPEED
	if not Input.is_action_pressed("ui_accept"):
		personaje.move_and_slide()
	
	# Comprueba si hubo colisiones durante este frame
	if personaje.get_slide_collision_count() > 0:
		set_random_direction()
		#print("Colisión detectada, nueva dirección aleatoria: ", direction)

# Función que asigna una nueva dirección basada en un ángulo aleatorio
func set_random_direction() -> void:
	var angle = rng.randf_range(0, TAU)  # TAU es 2π
	direction = Vector2(cos(angle), sin(angle)).normalized()
