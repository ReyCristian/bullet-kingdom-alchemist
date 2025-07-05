extends Arma
class_name ArmaMele

var objetivo: Objetivo

func apuntar(nuevo_objetivo: Objetivo) -> bool:
	if nodo_equipado and nuevo_objetivo:
		objetivo = nuevo_objetivo
		return true
	return false

func usar():
	if not esta_listo() or not nodo_equipado or not objetivo:
		return
		
	if AreaHelper.contiene_punto(obtener_rango(),objetivo.obtener_posicion()):
		return
		
	# Clon visual del arma
	var sprite = nodo_equipado.get_node_or_null("Sprite2D")
	var clon := sprite.duplicate()
	clon.global_position = objetivo.obtener_posicion()
	clon.modulate = Color(1, 1, 1, 0.7)
	nodo_equipado.get_tree().current_scene.add_child(clon)
	
	var animation: AnimationPlayer = clon.get_node_or_null("AnimationPlayer")
	if animation != null:
		animation.play("ataque_mele")

	# Programar desaparición del clon
	nodo_equipado.get_tree().create_timer(3.0).timeout.connect(func():
		if is_instance_valid(clon):
			clon.queue_free()
	)

	# Aplicar daño si es personaje
	if objetivo.personaje != null and objetivo.personaje is Personaje:
		hacer_daño(objetivo.personaje)

	super.usar()  # inicia cooldown
