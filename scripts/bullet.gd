extends Node2D

# Velocidad del proyectil
var velocidad: float = 500.0

func _process(delta):
	position += transform.x *   velocidad * delta

	# Si el proyectil sale de la pantalla, lo eliminamos
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
