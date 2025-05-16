extends ItemAtlas
class_name ItemTile


@export var tile_size: Vector2 = Vector2(18, 18)
@export var padding: Vector2 = Vector2(6, 6)
@export var margin: Vector2 = Vector2(7, 7)
@export var tile: Vector2 = Vector2(18,1)

func _ready() -> void:
	icono_vacio = generar_icono_desde_celda(tile.x,tile.y)
	inicializar_icono();

func generar_icono_desde_celda(col: int, fila: int) -> AtlasTexture:
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	var region_pos = margin + Vector2((col) * (tile_size.x + padding.x), (fila ) * (tile_size.y + padding.y))
	tex.region = Rect2(region_pos, tile_size)
	return tex
	
func set_icono_por_celda(col: int, fila: int) -> void:
	texture = generar_icono_desde_celda(col, fila)
