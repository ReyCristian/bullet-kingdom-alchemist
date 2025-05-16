extends ItemIcon
class_name ItemAtlas

@export var atlas:Texture2D = preload("res://Sprites/1bit 16px icons part-2 outlines.png")

func _ready() -> void:
	icono_vacio = generar_icono_desde_atlas(atlas,Rect2(Vector2(16,16),Vector2(16,16)))
	super._ready()

func generar_icono_desde_atlas(atlas: Texture2D, region: Rect2) -> AtlasTexture:
	var tex = AtlasTexture.new()
	tex.atlas = atlas
	tex.region = region
	return tex
