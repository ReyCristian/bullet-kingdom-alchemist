extends Area2D
class_name SpawnEnemigo

@onready var enemigos = [load("res://personajes/enemigo.tscn"),load("res://personajes/enemigo_2.tscn")]
@onready var bosses = [load("res://personajes/boss_final.tscn")]

var enemigo
var bool_spawn = true
var nivel = 1;
var enemigos_necesarios = 10
var nivel_boss = 5

signal nuevoNivel(nivel:int)

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.randomize()
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	spawn()
	$CanvasLayer/Control/tiempo_label.text = "%.1f" % $SubirNivel.time_left

var enemigos_vencidos = 0
var avance = 1000;

func spawn():
	if bool_spawn:
		
		avance +=1
		if avance > 10:
			avance = 0
			enemigo = enemigos.pick_random()
		
		#
		bool_spawn = false
		instanciar(enemigo)

func instanciar(_enemigo) -> Enemigo:
	var enemi_instance: Enemigo = _enemigo.instantiate()
	enemi_instance.position = Vector2(random.randf_range(-250, 400), random.randf_range(-50, 250))
	enemi_instance.set_nivel(nivel)
	add_child(enemi_instance)
	enemi_instance.muerte.connect(enemigo_vencido)
	return enemi_instance


func enemigo_vencido():
	enemigos_vencidos +=1
	mostrar_enemigos_vencidos()

func boss_vencido():
	$SubirNivel.paused = false;
	
func mostrar_enemigos_vencidos():
	var juego :ControladorJuego= get_tree().get_first_node_in_group("ControladorJuego")
	$CanvasLayer/Control/enemigos_label.text = " [color=%s]%d[/color] (%d)" % \
	["green" if enemigos_vencidos>enemigos_necesarios else "red",\
	enemigos_vencidos,\
	juego.monstruos_muertos]
	$CanvasLayer/Control/enemigos_label.tooltip_text = "Necesitas matar %d enemigos por nivel" % enemigos_necesarios
	StatsTooltip.guardarPuntaje($CanvasLayer/Control/enemigos_label.text)
	
func _on_timer_timeout() -> void:
	bool_spawn = true


func _on_subir_nivel_timeout() -> void:
	if enemigos_vencidos > enemigos_necesarios:
		nivel += 1
		nuevoNivel.emit(nivel)
		$CanvasLayer/Control/nivel_label.text = "Nivel: %d" % nivel
		enemigos_vencidos = 0
		if nivel % nivel_boss == 0:
			var boss = instanciar(bosses.pick_random())
			boss.muerte.connect(boss_vencido)
			$SubirNivel.paused = true;
	else:
		Alquimia.limpiar_pools()
		call_deferred("cambiar_a_menu_derrota")

func cambiar_a_menu_derrota():
	StatsTooltip.mostrar("Cada nivel, debes eliminar un minimo de %d enemigos, antes q termine el tiempo" % enemigos_necesarios)
	get_tree().change_scene_to_file("res://menu/menu_derrota.tscn")
