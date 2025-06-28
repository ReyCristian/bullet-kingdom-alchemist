class_name Item
extends Resource

@export var nombre_personalizado: String = ""
var nombre: String :get = get_nombre, set = set_nombre
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun
@export var tipo:TipoItem
@export var _atributos: Array[Atributo]
@export var nivel: int = 0;

var _rect: ItemRect :set = _set_rect 

enum Rareza {
	comun,
	raro,
	muy_raro,
	super_raro,
	rarisimo
}

func _init(t: TipoItem=null, r: ItemRect=null):
	if t:
		tipo = t
	if r:
		_rect = r

func get_rect() -> ItemRect:
	_rect.name = nombre
	return _rect

func _set_rect(value: ItemRect) -> void:
	if _rect == null:
		_rect = value
	else:
		push_error("Intento de sobrescribir el rect de un Item ya existente.")

func get_nombre() -> String:
	if nombre_personalizado != "":
		return nombre_personalizado
	return tipo.nombre + " " + rareza_to_string(rareza,tipo.genero)

func set_nombre(value: String) -> void:
	nombre_personalizado = value

static func rareza_to_string(r: Rareza,genero:String="a") -> String:
	match r:
		Rareza.comun: return "Mundan"+genero
		Rareza.raro: return "Distint"+genero
		Rareza.muy_raro: return "Peculiar"
		Rareza.super_raro: return "Bendit"+genero
		Rareza.rarisimo: return "Unic"+genero
		_: return "Sin rareza"

static func color_por_rareza(r: Rareza) -> String:
	match r:
		Rareza.raro: return "green"
		Rareza.muy_raro: return "#5050ff"
		Rareza.super_raro: return "#9e49b7"
		Rareza.rarisimo: return "gold"
		_: return "white"

func borrar():
	get_rect().contenedor.quitar(get_rect().indice);
	get_rect().borrar();

func descripcion() -> String:
	var texto = encabezado_descripcion()
	texto += "\n" + atributos_descripcion()
	return texto

func encabezado_descripcion() -> String:
	var texto := "[center][color=%s]%s[/color][/center]" % [color_por_rareza(rareza), get_nombre()]
	if nivel > 1:
		texto += "\nNivel " + str(nivel)
	return texto

func get_atributos() -> Array[Atributo]:
	_atributos.sort_custom(func(a:Atributo, b:Atributo):return a.tipo < b.tipo)
	return _atributos
	
func set_atributos(atr:Array[Atributo]):
	_atributos = atr;

func atributos_descripcion() -> String:
	var texto = "[font_size=5]"  # achicamos los atributos
	var dict = {}
	for atributo in get_atributos():
		Atributo.agregar_en(dict,atributo)
	texto += Atributo.get_descripcion(dict)
	texto += "[/font_size]"
	return texto

func mostrar_nivel():
	_rect.set_nivel(nivel%100)
	
func ocultar_nivel():
	_rect.ocultar_nivel()
	_rect.ocultar_atributos()

var timerBorrado: Timer = null

func tiempoVida(tiempo: float) -> Timer:
	if not _rect or (_rect and not is_instance_valid(_rect)):
		return null
	if timerBorrado and timerBorrado.is_inside_tree() and timerBorrado.time_left > 0.0:
		cancelarBorrado()

	timerBorrado = Timer.new()
	timerBorrado.one_shot = true
	timerBorrado.wait_time = tiempo
	_rect.add_child(timerBorrado)
	timerBorrado.timeout.connect(func():
		if is_instance_valid(timerBorrado):
			timerBorrado.queue_free()
		timerBorrado = null
		borrar()
	)
	timerBorrado.start()
	return timerBorrado


func cancelarBorrado():
	if timerBorrado and is_instance_valid(timerBorrado):
		timerBorrado.stop()
		timerBorrado.queue_free()
		timerBorrado = null
	else:
		push_error("no se canceló")
