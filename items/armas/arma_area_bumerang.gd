extends ArmaArea

func cambiar_icono():
	var sprite: Sprite2D = nodo_equipado.get_node_or_null("hitbox/Sprite2D")
	sprite.texture = tipo.icono.get_icono()
	sprite.scale = Vector2.ONE
	evitar_giro = false

func procesar_fisica(_delta: float) -> void:
	super.procesar_fisica(_delta)
	if nodo_equipado:
		var direccion := 1.0
		if mano == Personaje.Mano.IZQUIERDA:
			direccion = -1.0
		for item in nodo_equipado.get_children():
			if item is Node2D:
				item.rotation += direccion * PI * _delta
				item.rotation = fmod(item.rotation, TAU)
