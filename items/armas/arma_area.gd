extends Arma
class_name ArmaArea

@export var radio: float = 64.0
@export var resistencia = 3

func equipar(personaje: Node) -> void:
	super.equipar(personaje)
	get_cooldown_timer().one_shot = false
	get_cooldown_timer().start()
	
	if nodo_equipado != null:
		var area := nodo_equipado.get_node_or_null("hitbox/ataque")
		if area and area is Area2D:
			area.connect("body_entered", func(body):
				if body is Personaje:
					body.recibir_daño(daño_base)
		)

func usar():
	pass

func _cooldown_terminado():
	if nodo_equipado == null:
		return
	var fisico :CollisionShape2D = nodo_equipado.get_node_or_null("hitbox") as CollisionShape2D
	if fisico == null:
		return

	# Limitar cantidad de clones activos
	var offset_local: Vector2 = fisico.position
	for child in nodo_equipado.get_children():
		if child is CollisionShape2D:
			if AreaHelper.contiene_punto(child.get_node_or_null("ataque"),nodo_equipado.global_position + offset_local):
				return
	
	var clon: CollisionShape2D = fisico.duplicate()
	clon.modulate = Color(1, 1, 1, 1)
	nodo_equipado.add_child(clon)
	clon.global_position = nodo_equipado.global_position + offset_local
	clon.global_rotation = 0
	
	var area := clon.get_node_or_null("ataque")
	if area and area is Area2D:
		area.connect("body_entered", func(body):
			if body is Personaje:
				body.recibir_daño(daño_base)
				clon.modulate.a = clon.modulate.a - (1.0 / resistencia)
				if clon.modulate.a <= 0.1:
					clon.queue_free()
	)

func cambiar_icono():
	pass
	
func apuntar(_objetivo:Objetivo)->bool:
	return true
	
func set_capa_objetivo(capa_objetivo:int):
	if nodo_equipado:
		if nodo_equipado is PhysicsBody2D:
			nodo_equipado.collision_mask = capa_objetivo
		var area :Area2D= nodo_equipado.get_node_or_null("hitbox/ataque");
		if area != null:
			area.collision_mask = capa_objetivo;
