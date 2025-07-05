extends Enemigo2
class_name FinalBoss

var invocacion = preload("res://personajes/enemigo.tscn")

func _ready() -> void:
	vida = 2 ** (nivel-1)
	vida *= 10
	super._ready()
	


func _on_timer_timeout() -> void:
	var enemi_instance: Enemigo = invocacion.instantiate()
	enemi_instance.set_nivel(nivel)
	add_child(enemi_instance)
	enemi_instance.global_position = global_position
	enemi_instance.modulate = Color(0,0,0,0.5)
	enemi_instance.collision_mask = 0
	
