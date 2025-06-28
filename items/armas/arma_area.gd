extends Arma
class_name ArmaArea

@export var radio: float = 64.0
@export var resistencia = 3
var evitar_giro = true;

func equipar(_personaje: Node) -> void:
	super.equipar(_personaje)
	get_cooldown_timer().one_shot = false
	get_cooldown_timer().start()
	
	if nodo_equipado != null:
		var area := nodo_equipado.get_node_or_null("hitbox/ataque")
		if area and area is Area2D:
			area.connect("body_entered", func(body):
				if body is Personaje:
					hacer_daño(body)
		)

func usar():
	pass

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
			if AreaHelper.contiene_punto(child.get_node_or_null("ataque"),nodo_equipado.global_position + offset_local):
				return
	
	var clon: CollisionShape2D = fisico.duplicate()
	clon.modulate = Color(1, 1, 1, 1)
	nodo_equipado.add_child(clon)
	clon.add_to_group("clon")
	clon.global_position = nodo_equipado.global_position + offset_local
	clon.global_rotation = 0
	
	var area := clon.get_node_or_null("ataque")
	if area and area is Area2D:
		area.connect("body_entered", func(body):
			if body is Personaje:
				hacer_daño(body)
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

func procesar_fisica(_delta: float) -> void:
	super.procesar_fisica(_delta)
	if nodo_equipado and evitar_giro:
		for item in nodo_equipado.get_children():
			if item is Node2D:
				item.global_rotation = 0

func aplicar_atributos():
	
	var modificador_cooldown := Atributo.get_modificador(personaje.get_atributos(), Atributo.Tipo.VELOCIDAD_ATAQUE)
	var cooldown_modificado = cooldown * modificador_cooldown
	var frecuencia = 2 / cooldown_modificado
	var frecuenca_entera = floor(frecuencia)
	var cooldown_nuevo = 2 / max(1, frecuenca_entera)
	if get_cooldown_timer().wait_time != cooldown_nuevo:
		get_cooldown_timer().wait_time = cooldown_nuevo
		for clon:Node in nodo_equipado.get_children().filter(func (x:Node): return x.is_in_group("clon")):
			clon.queue_free()
			pass
	
