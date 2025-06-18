extends Node2D
class_name Proyectil

# Velocidad del proyectil
var velocidad: float = 500.0
var atributos:Dictionary = {}
var daño_base


func _process(delta):
	position += transform.x * velocidad * delta

	# Si el proyectil sale de la pantalla, lo eliminamos
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemigo:
		var daño = Daño.new(daño_base)
		daño.atributos_atacante = atributos
		body.recibir_daño(daño)
		queue_free()
