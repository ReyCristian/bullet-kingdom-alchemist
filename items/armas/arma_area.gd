extends Arma
class_name ArmaArea

@export var radio: float = 64.0

func usar():
	if not esta_listo() or not nodo_instanciado:
		return

	# Daño en área
	var cuerpos = nodo_instanciado.get_overlapping_bodies()
	for cuerpo in cuerpos:
		if cuerpo is Personaje and cuerpo != nodo_instanciado.get_parent():
			var golpeado:Personaje = cuerpo
			print("Dañando en área a:", golpeado.name)
			golpeado.recibir_daño(daño_base)

	super.usar()

func procesar_fisica(delta: float):
	# Podés dibujar el área o hacer efectos visuales
	pass
