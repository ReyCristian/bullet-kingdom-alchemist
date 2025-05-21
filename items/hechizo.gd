extends Item
class_name Hechizo

@export var objetivo: Objetivo

func usar():
	if objetivo:
		var pos = objetivo.obtener_posicion()
		print("Hechizo activado sobre posición:", pos)
