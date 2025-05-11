extends Contenedor
class_name Basurero

@export var icono_tacho: Texture2D

func _ready():
	set_tamaño(1, 1)

func agregar(item: Item, fila: int, columna: int) -> bool:
	print("Item destruido:", item.nombre)
	return true

func quitar(fila: int, columna: int) -> Item:
	return null

func _crear_slot(index: int) -> Control:
	var slot = TextureRect.new()
	slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	slot.texture = icono_tacho
	slot.name = "Basurero"
	return slot

func _actualizar_slot(index: int) -> void:
	pass  # No se actualiza visualmente
