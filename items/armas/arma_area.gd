extends Arma
class_name ArmaArea

@export var radio: float = 64.0

func equipar(personaje: Node) -> void:
	super.equipar(personaje)
	get_cooldown_timer().one_shot = false
	get_cooldown_timer().start()

func usar():
	pass

func _cooldown_terminado():
	var fisico := nodo_equipado.get_node_or_null("hitbox")
	if fisico == null:
		return

	var clon := fisico.duplicate()
	clon.modulate = Color(1, 1, 1, 0.7)
	nodo_equipado.add_child(clon)
	var offset_local: Vector2 = fisico.position
	clon.global_position = nodo_equipado.global_position + offset_local
	clon.global_rotation = 0

	nodo_equipado.get_tree().create_timer(5.0).timeout.connect(func():
		if is_instance_valid(clon):
			clon.queue_free()
	)

func cambiar_icono():
	pass
	
func apuntar(_objetivo:Objetivo)->bool:
	return true
