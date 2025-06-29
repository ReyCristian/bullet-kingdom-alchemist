extends Proyectil
class_name AtaqueEnemigo

func _ready() -> void:
	velocidad = 100
	
func _physics_process(_delta: float) -> void:
	$Sprite2D.global_rotation = 0;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Heroe:
		var daño = Daño.new(daño_base)
		daño.atributos_atacante = atributos
		body.recibir_daño(daño)
		queue_free()
