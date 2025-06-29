extends CanvasLayer

@onready var label: RichTextLabel = $StatsTooltip/RichTextLabel
@onready var panel: Panel = $StatsTooltip

var seguir_mouse := false
var mostrar_timer := Timer.new()


func _ready():
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mostrar_timer.one_shot = true
	mostrar_timer.wait_time = 0.2
	mostrar_timer.timeout.connect(_mostrar_retardado)
	add_child(mostrar_timer)

func mostrar(texto: String, _posicion: Vector2=Vector2.ZERO):
	label.text = texto
	seguir_mouse = true
	mostrar_timer.start()

func mostrarDerrota(_posicion: Vector2):
	panel.visible = true
	seguir_mouse = false
	panel.position = _posicion

func _mostrar_retardado():
	panel.visible = true

func ocultar():
	mostrar_timer.stop()
	panel.visible = false
	seguir_mouse = false

func _process(_delta):
	if seguir_mouse:
		var raw_pos = get_viewport().get_mouse_position() + Vector2(3, 3)
		var screen_size = get_viewport().get_visible_rect().size
		var size = panel.size
		var final_pos = raw_pos

		if final_pos.x + size.x > screen_size.x:
			final_pos.x = screen_size.x - size.x
		if final_pos.y + size.y > screen_size.y:
			final_pos.y = screen_size.y - size.y

		panel.position = final_pos
