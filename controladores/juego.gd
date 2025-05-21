extends Node2D
class_name ControladorJuego

var lista_items :Array[Item] = []
var dropeados = {}
var intento = {}
var monstruos_muertos = 0

var probas = {
	Item.Rareza.comun: 0.25,
	Item.Rareza.raro: 0.20,
	Item.Rareza.muy_raro: 0.10,
	Item.Rareza.super_raro: 0.07,
	Item.Rareza.rarisimo: 0.01,
}

var toast_tween: Tween = null

func _ready():
	cargar_items_desde("res://items/creados/")

func cargar_items_desde(ruta: String):
	var dir = DirAccess.open(ruta)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var recurso = load(ruta + file_name)
				if recurso is Item:  # Aseguramos que sea del tipo correcto
					lista_items.append(recurso)
			file_name = dir.get_next()
		dir.list_dir_end()

func _on_child_entered_tree(node: Node) -> void:
	if node is Enemigo:
		node.muerte.connect(muerte_enemigo.bind(node))
	pass # Replace with function body.


func muerte_enemigo(e: Node):
	monstruos_muertos += 1

	if lista_items.size() == 0:
		return

	var r = randf()
	var acumulado = 0.0

	var candidatos = []

	for rareza in probas.keys():
		acumulado += probas[rareza]
		if r < acumulado:
			var rareza_seleccionada: Item.Rareza = rareza
			candidatos = lista_items.filter(func(i): return i.rareza == rareza_seleccionada)
			break

	if candidatos.size() > 0:
		var item_random = candidatos[randi() % candidatos.size()].duplicate()
		$ContenedorItemsSueltos.soltar(item_random, e.global_position)

		var nombre = item_random.nombre
		if not dropeados.has(nombre):
			dropeados[nombre] = 0
		dropeados[nombre] += 1
	if monstruos_muertos <= 10 or (monstruos_muertos <= 50 and monstruos_muertos % 5 == 0) or (monstruos_muertos % 50 == 0):
		mostrar_toast("Enemigos   Vencidos: " + str(monstruos_muertos) + ", Drops: " + str(dropeados))



func tomar_item(item: Item) -> void:
	var queda = $Deidad.tomar_item(item)
	if queda != null:
		queda.get_rect().mouse_entered.connect(tomar_item.bind(item),ConnectFlags.CONNECT_ONE_SHOT)
	pass

func mostrar_toast(mensaje: String, duracion: float = 2.0):
	var toast = $CanvasLayer/ToastLabel
	toast.text = mensaje
	toast.visible = true
	toast.modulate.a = 1.0
	
	if toast_tween:
		toast_tween.kill()

	toast_tween  = create_tween()
	toast_tween .tween_interval(duracion)
	toast_tween .tween_property(toast, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	toast_tween .tween_callback(func():
		toast.visible = false
	)
