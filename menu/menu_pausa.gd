extends Control


func _on_continuar_pressed():
	get_tree().paused = false  # Reanuda el juego
	#$pausa.stream_paused = true
	get_parent().visible=false
	#queue_free()  # Cierra el menú de pausa

func _on_menu_principal_pressed():
	get_tree().paused = false  # Asegúrate de despausar antes de cambiar la escena
#	$pausa.stream_paused = true
	Alquimia.limpiar_pools()
	get_tree().change_scene_to_file("res://menu/menu_principal.tscn")  # Volver al menú principal

func _on_salida_pressed():
	get_tree().quit()  # Salir del juego


func _on_opciones_pressed() -> void:
	$"../MenuOpciones".visible=true
	self.visible=false
