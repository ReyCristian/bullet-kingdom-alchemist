extends Arma
class_name ArmaMele

func usar():
	if not esta_listo() or not nodo_equipado:
		return

	# Lógica de golpe
	print("Ataque cuerpo a cuerpo desde", nodo_equipado.name)

	super.usar()

func procesar_fisica(delta: float):
	pass
