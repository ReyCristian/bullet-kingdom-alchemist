extends Personaje
class_name Heroe

func morir():
	#print("reiniciando")
	Alquimia.limpiar_pools()
	#get_tree().reload_current_scene()
	call_deferred("cambiar_a_menu_derrota")

func cambiar_a_menu_derrota():
	StatsTooltip.mostrar("Si tu vida llega a 0 mueres")
	get_tree().change_scene_to_file("res://menu/menu_derrota.tscn")

func _ready() -> void:
	vida = 20
	super._ready()

func set_nivel(_nivel:int):
	var vida_perdida = vida - vida_actual
	super.set_nivel(_nivel)
	vida = 2 ** (nivel-1) * 20
	vida_actual = clamp(vida - vida_perdida, 1, vida)
	actualizar_barra_vida()
	
