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

static func cargar_recetas_desde_csv(_ruta: String = "") -> Array[Receta]:
	return cargar_recetas_embebidas()
	
static func cargar_recetas_embebidas() -> Array[Receta]:
	var data: Array = [
		["cuero","escudo","casco"],["cuero","varita","daga"],["cuero","arco","arco"],["cuero","botas","botas"],["cuero","casco","casco"],["cuero","pechera","casco"],["cuero","lanza","arco"],["cuero","arrojadiza","bumerang"],["cuero","hacha","hacha"],["cuero","espada","daga"],
		["bumerang","bumerang","bumerang"],["bumerang","daga","pechera"],["bumerang","escudo","varita"],["bumerang","varita","escudo"],["bumerang","arco","pechera"],["bumerang","botas","arrojadiza"],["bumerang","casco","arrojadiza"],["bumerang","pechera","arco"],["bumerang","lanza","arrojadiza"],["bumerang","arrojadiza","botas"],["bumerang","hacha","arco"],["bumerang","espada","arrojadiza"],
		["daga","daga","daga"],["daga","escudo","pechera"],["daga","varita","botas"],["daga","arco","arrojadiza"],["daga","botas","hacha"],["daga","casco","hacha"],["daga","pechera","lanza"],["daga","lanza","pechera"],["daga","arrojadiza","arco"],["daga","hacha","botas"],["daga","espada","pechera"],
		["escudo","escudo","escudo"],["escudo","varita","bumerang"],["escudo","arco","pechera"],["escudo","botas","arrojadiza"],["escudo","casco","arrojadiza"],["escudo","pechera","daga"],["escudo","lanza","arrojadiza"],["escudo","arrojadiza","casco"],["escudo","hacha","daga"],["escudo","espada","arrojadiza"],
		["varita","varita","varita"],["varita","arco","casco"],["varita","botas","daga"],["varita","casco","arco"],["varita","pechera","daga"],["varita","lanza","daga"],["varita","arrojadiza","casco"],["varita","hacha","daga"],["varita","espada","arco"],
		["arco","arco","arco"],["arco","botas","hacha"],["arco","casco","hacha"],["arco","pechera","espada"],["arco","lanza","pechera"],["arco","arrojadiza","daga"],["arco","hacha","casco"],["arco","espada","pechera"],
		["botas","botas","botas"],["botas","casco","pechera"],["botas","pechera","casco"],["botas","lanza","varita"],["botas","arrojadiza","espada"],["botas","hacha","bumerang"],["botas","espada","varita"],
		["casco","casco","casco"],["casco","pechera","botas"],["casco","lanza","varita"],["casco","arrojadiza","lanza"],["casco","hacha","escudo"],["casco","espada","varita"],
		["pechera","pechera","pechera"],["pechera","lanza","bumerang"],["pechera","arrojadiza","espada"],["pechera","hacha","bumerang"],["pechera","espada","escudo"],
		["lanza","lanza","lanza"],["lanza","arrojadiza","casco"],["lanza","hacha","espada"],["lanza","espada","hacha"],
		["arrojadiza","arrojadiza","arrojadiza"],["arrojadiza","hacha","casco"],["arrojadiza","espada","botas"],
		["hacha","hacha","hacha"],["hacha","espada","lanza"],
		["espada","espada","espada"]
	]

	var recetas: Array[Receta] = []
	for fila in data:
		var ingrediente_1: TipoItem = ITEMS.get(fila[0], null)
		var ingrediente_2: TipoItem = ITEMS.get(fila[1], null)
		var resultado: TipoItem = ITEMS.get(fila[2], null)

		if ingrediente_1 and ingrediente_2 and resultado:
			var receta: Receta = crear_receta([ingrediente_1, ingrediente_2], resultado)
			recetas.append(receta)
		else:
			push_warning("Ítems no encontrados en receta embebida: %s" % fila)

	return recetas
