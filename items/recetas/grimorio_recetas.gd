extends Node
class_name GrimorioRecetas

static var ITEMS: Dictionary = {
	# 🧱 Recurso
	"chatarra": preload("res://items/tipos/recurso/chatarra.tres"),
	"cuero": preload("res://items/tipos/recurso/cuero.tres"),
	"madera": preload("res://items/tipos/recurso/madera.tres"),

	# 🛡️ Armadura
	"botas": preload("res://items/tipos/armadura/botas.tres"),
	"casco": preload("res://items/tipos/armadura/casco.tres"),
	"pechera": preload("res://items/tipos/armadura/pechera.tres"),

	# ⚔️ Arma Mele
	"espada": preload("res://items/tipos/arma_mele/espada.tres"),
	"hacha": preload("res://items/tipos/arma_mele/hacha.tres"),
	"lanza": preload("res://items/tipos/arma_mele/lanza.tres"),

	# 🏹 Arma Rango
	"arco": preload("res://items/tipos/arma_rango/arco.tres"),
	"arrojadiza": preload("res://items/tipos/arma_rango/arrojadiza.tres"),
	"daga": preload("res://items/tipos/arma_rango/daga.tres"),

	# ✨ Arma Área
	"bumerang": preload("res://items/tipos/arma_area/bumerang.tres"),
	"escudo": preload("res://items/tipos/arma_area/escudo.tres"),
	"varita": preload("res://items/tipos/arma_area/varita.tres")
}


static func crear_receta(ingredientes: Array[TipoItem], resultado: TipoItem) -> Receta:
	var receta: Receta = Receta.new()
	receta.ingredientes = ingredientes
	receta.resultado = resultado
	return receta

static func cargar_recetas_desde_csv(ruta: String = "res://items/recetas/recetas.csv") -> Array[Receta]:
	var recetas: Array[Receta] = []
	var archivo: FileAccess = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("No se pudo abrir el archivo de recetas: %s" % ruta)
		return recetas

	var encabezado: String = archivo.get_line() # Saltamos la primera línea

	while not archivo.eof_reached():
		var linea: String = archivo.get_line().strip_edges()
		if linea == "":
			continue

		var partes: PackedStringArray = linea.split(";")
		if partes.size() < 3:
			continue

		var ingrediente_1: TipoItem = ITEMS.get(partes[0].strip_edges(), null)
		var ingrediente_2: TipoItem = ITEMS.get(partes[1].strip_edges(), null)
		var resultado: TipoItem = ITEMS.get(partes[2].strip_edges(), null)

		if ingrediente_1 and ingrediente_2 and resultado:
			var receta: Receta = crear_receta([ingrediente_1, ingrediente_2], resultado)
			recetas.append(receta)
		else:
			push_warning("Ítems no encontrados en línea: %s" % linea)

	return recetas
