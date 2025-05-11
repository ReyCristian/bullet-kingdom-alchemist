extends ItemAtlas
class_name ItemTile


@export var tile_size: Vector2 = Vector2(16, 16)
@export var padding: Vector2 = Vector2(8, 8)

func _ready() -> void:
	icono_vacio = generar_icono_desde_celda(18,1)
	super._ready()

func generar_icono_desde_celda(col: int, fila: int) -> AtlasTexture:
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	var region_pos = padding + Vector2((col - 1) * tile_size.x, (fila - 1) * tile_size.y)
	tex.region = Rect2(region_pos, tile_size)
	return tex
	
func set_icono_por_celda(col: int, fila: int) -> void:
	texture = generar_icono_desde_celda(col, fila)
