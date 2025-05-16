extends ItemAtlas
class_name ItemTile


@export var tile_size: Vector2 = Vector2(18, 18)
@export var padding: Vector2 = Vector2(6, 6)
@export var margin: Vector2 = Vector2(7, 7)
@export var tile: Vector2 = Vector2(18,1) :set = set_tile

func generar_icono_desde_celda(col: int, fila: int) -> AtlasTexture:
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	var region_pos = margin + Vector2((col) * (tile_size.x + padding.x), (fila ) * (tile_size.y + padding.y))
	tex.region = Rect2(region_pos, tile_size)
	return tex
	
func set_tile(_tile:Vector2) -> void:
	tile = _tile
	icono = generar_icono_desde_celda(int(tile.x), int(tile.y))
	
func get_icono() -> Texture2D:
	return generar_icono_desde_celda(int(tile.x), int(tile.y))
