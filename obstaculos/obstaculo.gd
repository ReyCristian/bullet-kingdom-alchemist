extends StaticBody2D
class_name Obstaculo

@export var resistencia: int = 1

func recibir_golpe():
	resistencia -= 1
	if resistencia <= 0:
		destruir()

func destruir():
	queue_free()
