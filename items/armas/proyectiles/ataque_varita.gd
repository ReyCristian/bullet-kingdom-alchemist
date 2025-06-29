extends Proyectil

var estaExplotando = false

func _ready() -> void:
	velocidad = 150
	
func _physics_process(_delta: float) -> void:
	$Sprite2D.global_rotation = 0;
	if estaExplotando:
		var enemigos = $Area2D.get_overlapping_bodies().filter(func(x): return x is Enemigo)
		for enemigo in enemigos:
			var daño = Daño.new(daño_base)
			daño.atributos_atacante = atributos
			enemigo.recibir_daño(daño)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not estaExplotando and body is Enemigo:
		estaExplotando = true
		velocidad = 0
		var tween := create_tween()
		
		var color_final := Color(0.4,0.05,0.05,0.8)
		$Sprite2D.modulate = Color(1.0, 0.6, 0.1, 0.8)
		tween.tween_property(self, "scale", scale * 5, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property($Sprite2D, "modulate", color_final, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		await tween.finished
		estaExplotando = false
		$Area2D.queue_free()
		await get_tree().create_timer(0.3).timeout
		queue_free()
