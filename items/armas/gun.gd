extends Node2D
const  bullet = preload("res://items/armas/proyectiles/bullet.tscn")																												
# Referencia a la escena del proyectil

func _physics_process(delta: float) -> void:
	disparar()
	
	movimiento()
 																	


func disparar():
	var shot = bullet.instantiate( )
	if Input.is_action_just_pressed("shot"):
		get_parent().add_child(shot)
		shot.global_position = global_position
		shot.rotation = rotation
		
func movimiento():
	look_at(get_global_mouse_position())
		
