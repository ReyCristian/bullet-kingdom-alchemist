extends Enemigo
class_name Enemigo2

func _ready() -> void:
	ataques = [AtaqueAutomatico.new((1 << 0)),AtaqueAutomatico.new((1 << 0) | (1 << 0))]
	super._ready()
	pass

func _physics_process(_delta):
	if personaje and personaje.global_position.distance_to(global_position) > 100:
		super._physics_process(_delta)
	else:
		velocity = Vector2.ZERO
	var ataque = ataques[0]
	if ataque:
		ataque.objetivo = null
		ataque.procesar_fisica(_delta)

func _al_entrar_area_en_hitbox(_area: Area2D) -> void:
	pass
