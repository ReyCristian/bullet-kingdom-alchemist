extends Resource
class_name TipoItem


@export var icono: ItemIcon
@export var grupo: Grupo
@export var nombre: String = "Item sin nombre"

enum Grupo {
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
