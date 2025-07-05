extends Personaje
class_name Enemigo

var personaje:Personaje = null

func _ready() -> void:
	SPEED = 50;
	personaje = get_tree().get_nodes_in_group("personaje")[0]
	if (vida==-1):
		vida = calcular_vida(nivel)
	super._ready()

static func calcular_vida(_nivel:int) -> float:
	return 2 ** (_nivel-1)

func _physics_process(_delta):
	if personaje:
		var direction = (personaje.global_position - global_position).normalized()
		velocity = direction * get_speed()
		#$AnimatedSprite2D2.play()
		if direction.x > 0:
			$AnimationPlayer.play("derecha")
		else:
			$AnimationPlayer.play("izquierda")
		move_and_slide()

	


func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass

func _al_entrar_area_en_hitbox(area: Area2D) -> void:
	if area.is_in_group("personaje") :
		var ataque_enemigo = Daño.new(vida)
		ataque_enemigo.atributos_atacante = _calcular_atributos()
		personaje.recibir_daño(ataque_enemigo)
		queue_free()

func set_nivel(_nivel: int) -> void:
	super.set_nivel(_nivel);
	
	var rng := RandomNumberGenerator.new();
	rng.seed = _nivel; # Usamos el nivel como semilla
	
	var color := Color(
		rng.randf_range(0.2, 1.0), # rojo
		rng.randf_range(0.2, 1.0), # verde
		rng.randf_range(0.2, 1.0), # azul
		1.0                        # alfa
	);
	
	$Sprite2D.modulate = color;
