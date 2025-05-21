extends CanvasLayer
class_name Deidad

var inventario: Inventario
var forja: Forja
var basurero: Basurero
var equipamento: Equipamento
@export var icono_inicial:Icono

func _ready():
	icono_navegador_clickeado(icono_inicial)
	deshabilitar_vacios();
	if equipamento and inventario:
		inventario.contenedores_click_secundario.append(equipamento.contenedor_armas)
		inventario.contenedores_click_secundario.append(equipamento.contenedor_armadura)

func entra_panel(child: Node):
	if child is Inventario:
		inventario = child
	elif child is Forja:
		forja = child
	elif child is Basurero:
		basurero = child
	elif child is Equipamento:
		equipamento = child
	deshabilitar_vacios();

func sale_panel(_child: Node):
	deshabilitar_vacios();

func entra_navegador(child: Node):
	if child is Icono:
		var icono = child as Icono
		icono.clickeado.connect(icono_navegador_clickeado.bind(icono))

func deshabilitar_vacios():
	for icono in $Navegador.get_children():
		if icono == null or not icono is Icono:
			continue
	
		var grupos = icono.get_groups()
		var vacio = not $Panel.get_children().any(func(nodo):return grupos.any(func(grupo): return nodo.is_in_group(grupo)))
		if vacio:
			icono.habilitado = false

func icono_navegador_clickeado(icono: Icono):
	seleccionar(icono)
	var grupos = icono.get_groups()
	for nodo in $Panel.get_children():
		nodo.visible = grupos.any(func(g): return nodo.is_in_group(g))
	
func seleccionar(_icono: Icono):
	for icono in $Navegador.get_children():
		var nuevo_valor = (icono == _icono)
		if icono.seleccionado != nuevo_valor:
			icono.seleccionado = nuevo_valor

func tomar_item(item: Item) -> Item:
	return inventario.agregar(item)
