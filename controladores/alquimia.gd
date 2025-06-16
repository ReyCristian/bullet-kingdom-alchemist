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

func crear(tipo: TipoItem, nivel: int = 1, rareza = elegir_rareza_aleatoria()) -> Item:
	var nuevo_item :Item= fabricar(tipo,nivel,rareza)
	if nuevo_item == null:
		return null;
	if (nivel > 0):
		nuevo_item.atributos.append(Atributo.crear(nivel,nuevo_item.rareza))
	nuevo_item.nivel = nivel;
	return nuevo_item

func fabricar(tipo: TipoItem, nivel:int = 1,rareza = elegir_rareza_aleatoria()) -> Item:
	var rect := obtener_item_rect()
	if rect == null:
		return null
		
	rect.load_icono(tipo.icono)
	
	var clase = tipo.clase_item
	if clase == null:
		push_error("Tipo de Item sin clase asociada: " + tipo.nombre)
		return null

	var nuevo_item:Item = clase.new()  # instancia Arma, Armadura, etc.
	nuevo_item.tipo = tipo
	nuevo_item._set_rect(rect)
	return nuevo_item

func combinar(item1: Item, item2: Item, resultado: TipoItem) -> Item:
	var mapa_atributos: Dictionary = {}
	
	for atributo in item1.atributos + item2.atributos:
		var tipo := atributo.tipo
		if mapa_atributos.has(tipo):
			mapa_atributos[tipo].valor += atributo.valor
		else:
			mapa_atributos[tipo] = atributo.duplicate()
	
	item1.borrar()
	item2.borrar()
	
	var rareza := item1.rareza if item1.rareza > item2.rareza else item2.rareza
	var nuevo :Item= fabricar(resultado, item1.nivel + 1, rareza)
	var atributos: Array[Atributo] = []
	for a in mapa_atributos.values():
		atributos.append(a as Atributo)
	nuevo.atributos = atributos;
	nuevo.nivel = item1.nivel + 1
	return nuevo

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

func elegir_rareza_aleatoria() -> Item.Rareza:

	var total := 0.0
	for p in _probas.values():
		total += p

	var r := randf() * total
	var acumulado := 0.0

	for rareza in _probas.keys():
		acumulado += _probas[rareza]
		if r <= acumulado:
			return rareza

	return Item.Rareza.comun

func duplicar_item(base: Item) -> Item:
	var rect = obtener_item_rect()
	if rect == null:
		return null
	rect.load_icono(base.tipo.icono)
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
	
func limpiar_pools():
	pool_item_rects.clear()
	pool_nodos_fisicos.clear()
