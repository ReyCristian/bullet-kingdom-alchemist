extends CanvasLayer

@export var tiempo_entre_apariciones: float = 1.0
@export var duracion_fade: float = 1.0

func _ready() -> void:
	for nodo in get_children():
		nodo.modulate.a = 0.0
	mostrar_todos()

func mostrar_todos() -> void:
	await _aparecer_hijos()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://menu/menu_principal.tscn")

func _aparecer_hijos() -> void:
	for nodo in get_children():
		await _fade_in(nodo)
		await get_tree().create_timer(tiempo_entre_apariciones).timeout
		await _fade_out(nodo)
	

func _fade_in(nodo: CanvasItem) -> void:
	var tiempo: float = 0.0
	var duracion: float = duracion_fade
	while tiempo < duracion:
		tiempo += get_process_delta_time()
		nodo.visible = true
		nodo.modulate.a = clamp(tiempo / duracion, 0.0, 1.0)
		await get_tree().process_frame
	nodo.modulate.a = 1.0
	
func _fade_out(nodo: CanvasItem) -> void:
	var tiempo: float = 0.0
	var duracion: float = duracion_fade
	while tiempo < duracion:
		tiempo += get_process_delta_time()
		nodo.visible = true
		nodo.modulate.a = 1.0 - clamp(tiempo / duracion, 0.0, 1.0)
		await get_tree().process_frame
	nodo.modulate.a = 0.0
