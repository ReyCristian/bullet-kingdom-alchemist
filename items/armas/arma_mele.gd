extends Arma
class_name ArmaMele

func usar():
	if not esta_listo() or not nodo_instanciado:
		return

	# Lógica de golpe
	print("Ataque cuerpo a cuerpo desde", nodo_instanciado.name)

	super.usar()

func procesar_fisica(delta: float):
	pass
