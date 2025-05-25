extends Node

var pool_item_rects: Array[ItemRect] = []
var pool_nodos_fisicos: Dictionary = {}

const MAX_RECTS = 40;

var _probas = {
	Item.Rareza.comun: 0.25,
	Item.Rareza.raro: 0.20,
	Item.Rareza.muy_raro: 0.10,
	Item.Rareza.super_raro: 0.07,
	Item.Rareza.rarisimo: 0.01,
}

func fabricar(tipo: TipoItem) -> Item:
	var rect := obtener_item_rect()
	if rect:
		rect.icono_default = tipo.icono
		return Item.new(tipo, rect)
	return null;
	
func obtener_item_rect() -> ItemRect:
	for r in pool_item_rects:
		if !r.get_parent():
			r.visible = true
			return r
	if pool_item_rects.size() >= MAX_RECTS:
		return null
	var nuevo = ItemRect.new()
	pool_item_rects.append(nuevo)
	return nuevo
	
func seleccionar_item(lista_items: Array[Item], probas: Dictionary = _probas) -> Item:
	if lista_items.size() == 0:
		return null

	var r = randf()
	var acumulado = 0.0

	for rareza in probas.keys():
		acumulado += probas[rareza]
		if r < acumulado:
			var candidatos = lista_items.filter(func(i): return i.rareza == rareza)
			if candidatos.size() > 0:
				var elegido = candidatos[randi() % candidatos.size()]
				if elegido is Item:
					return Alquimia.duplicar_item(elegido)
			break
	return null

func duplicar_item(base: Item) -> Item:
	var rect = obtener_item_rect()
	if rect == null:
		return null
	rect.icono_default = base.tipo.icono
	rect.name = base.nombre

	var nuevo = base.duplicate()
	nuevo._rect = rect
	return nuevo

func regresar_al_eter(rect: ItemRect) -> void:
	if rect.get_parent():
		rect.get_parent().remove_child(rect)
	rect.visible = false
	rect.modulate.a = 1.0  # Restaura opacidad
	rect.icono_default = null
	rect.name = "🜁"  #símbolo arcano de reciclado
