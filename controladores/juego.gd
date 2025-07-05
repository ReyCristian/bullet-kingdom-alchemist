extends Node2D
class_name ControladorJuego

var dropeados = {}
var intento = {}
var monstruos_muertos = 0
var pause_menu

var toast_tween: Tween = null

var drops = [load("res://items/tipos/recurso/chatarra.tres"),
load("res://items/tipos/recurso/madera.tres"),
load("res://items/tipos/recurso/cuero.tres")]

func _ready() -> void:
	RenderingServer.set_default_clear_color("#000000")
	pause_menu = preload("res://menu/menu_pausa.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.visible=false

func _on_child_entered_tree(node: Node) -> void:
	if node is Enemigo:
		node.muerte.connect(muerte_enemigo.bind(node))
	pass # Replace with function body.


func muerte_enemigo(e: Node):
	monstruos_muertos += 1
	var nivel = e.nivel if e is Enemigo else 1
	if (randf()<1):
		var drop = Alquimia.crear(drops.pick_random(),nivel)
		if drop:
			$Mapa/ItemsSueltos.soltar(drop, e.global_position)

			var nombre = drop.nombre
			if not dropeados.has(nombre):
				dropeados[nombre] = 0
			dropeados[nombre] += 1
	if monstruos_muertos <= 10 or (monstruos_muertos <= 50 and monstruos_muertos % 5 == 0) or (monstruos_muertos % 50 == 0):
		mostrar_toast("Enemigos Vencidos: " + str(monstruos_muertos))



func tomar_item(item: Item) -> void:
	var queda = await $Deidad.tomar_item(item)
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

func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):  # La tecla "Escape"
		boton_pause()

func boton_pause():
		$Deidad/TextureButton.set_pressed(not pause_menu.visible)
		if not pause_menu.visible:
			pause_game()
		else:
			unpause_game()

func pause_game():
	pause_menu.visible=true
	#pause_menu.get_node("menu_pausa/pausa").play()
	get_tree().paused = true  # Pausa el árbol de nodos


func unpause_game():
	pause_menu.visible=false
	#pause_menu.get_node("menu_pausa/pausa").stream_paused=true
	get_tree().paused = false  # Reanuda el juego
	


func _on_nuevo_nivel(nivel: int) -> void:
	$Mapa/Personaje.set_nivel(nivel)
