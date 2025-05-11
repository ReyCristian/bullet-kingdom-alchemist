extends Obstaculo
class_name Cofre

@export var escena_contenedor: PackedScene
@export var items: Array[Item] = [null, null, null, null, null]
var contenedor: Contenedor_Cofre



func _ready():
	resistencia = 0  # No se destruye, solo se abre

func recibir_golpe():
	if not contenedor and escena_contenedor:
		contenedor = escena_contenedor.instantiate()
		contenedor.cofre = self
		get_tree().current_scene.add_child(contenedor)
	if contenedor:
		contenedor.abrir()
