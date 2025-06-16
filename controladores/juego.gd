extends Node2D
class_name ControladorJuego

var dropeados = {}
var intento = {}
var monstruos_muertos = 0

var toast_tween: Tween = null

var drops = [load("res://items/tipos/recurso/chatarra.tres"),
load("res://items/tipos/recurso/madera.tres"),
load("res://items/tipos/recurso/cuero.tres")]

func _on_child_entered_tree(node: Node) -> void:
	if node is Enemigo:
		node.muerte.connect(muerte_enemigo.bind(node))
	pass # Replace with function body.


func muerte_enemigo(e: Node):
	monstruos_muertos += 1
	if (randf()<1):
		var drop = Alquimia.crear(drops.pick_random())
		if drop:
			$ContenedorItemsSueltos.soltar(drop, e.global_position)

			var nombre = drop.nombre
			if not dropeados.has(nombre):
				dropeados[nombre] = 0
			dropeados[nombre] += 1
	if monstruos_muertos <= 10 or (monstruos_muertos <= 50 and monstruos_muertos % 5 == 0) or (monstruos_muertos % 50 == 0):
		mostrar_toast("Enemigos Vencidos: " + str(monstruos_muertos) + ", Drops: " + str(dropeados))



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
