class_name Item
extends Resource

@export var icon: Texture2D
@export var tipo: TipoItem
@export var nombre: String = "Item sin nombre"
@export var peso: float = 1.0
@export var rareza: Rareza = Rareza.comun

@export var nodo_uso: PackedScene


enum Rareza {
	comun,
	raro,
	muy_raro,
	super_raro,
	rarisimo
}

enum TipoItem {
	Espada,
	Hacha,
	Lanza,
	Arco,
	Daga_arrojadiza,
	Hacha_arrojadiza,
	Escudo,
	Varita,
	Bumerang,
	Casco,
	Pechera,
	Botas,
	Chatarra,
	Maderita,
	Cuero
}
