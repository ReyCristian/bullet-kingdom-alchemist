extends ArmaArea

func cambiar_icono():
	var sprite: Sprite2D = nodo_equipado.get_node_or_null("hitbox/Sprite2D")
	sprite.texture = tipo.icono.get_icono()
	sprite.scale = Vector2.ONE
	evitar_giro = false
	
	if nodo_equipado is CharacterBody2D:
		nodo_equipado.collision_layer = 0;
		
	var animador = nodo_equipado.get_node_or_null("hitbox/spawn/AnimationPlayer")
	if animador and animador is AnimationPlayer:
		if mano == Personaje.Mano.IZQUIERDA:
			animador.play("movimiento_otra_mano")
		else:
			animador.play("movimiento")
	
	resistencia = -1
	
	
	
func _cooldown_terminado():
	if nodo_equipado == null:
		return
	var fisico :CollisionShape2D = nodo_equipado.get_node_or_null("hitbox") as CollisionShape2D
	if fisico == null:
		return
		
	aplicar_atributos()

	# Limitar cantidad de clones activos
	var offset_local: Vector2 = fisico.position
	for child in nodo_equipado.get_children():
		if child is CollisionShape2D:
			if AreaHelper.contiene_punto(child.get_node_or_null("spawn"),nodo_equipado.global_position + offset_local):
				return
	var clon = crear_clon(fisico,nodo_equipado.global_position + offset_local)
	var animador = clon.get_node_or_null("spawn/AnimationPlayer")
	if animador and animador is AnimationPlayer:
		if mano == Personaje.Mano.IZQUIERDA:
			animador.play("movimiento_otra_mano")
		else:
			animador.play("movimiento")
