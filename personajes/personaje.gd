extends CharacterBody2D
class_name Personaje

var nombre: String = "SinNombre"
@export var vida: int = 100
var arma_equipada: Array[Arma] = [null, null]
var armadura_equipada: Array[Armadura] = [null, null, null]
enum Mano { IZQUIERDA, DERECHA }
var ultima_arma: bool = true  # true = arma[0], false = arma[1]

signal muerte
signal equipa_armadura(slot:int,prev:Armadura, nuevo:Armadura)
signal equipa_arma(slot:int,prev:Arma, nuevo:Arma)

@export var item_inicial:Equipable;

var movimiento: Movimiento = MovimientoAutomatico.new()
var ataques: Array[Ataque]= [AtaqueAutomatico.new((1 << 1)),AtaqueAutomatico.new((1 << 1) | (1 << 1))]

func _ready() -> void:
	ataques[Mano.IZQUIERDA].equipar(self,Mano.IZQUIERDA)
	ataques[Mano.DERECHA].equipar(self,Mano.DERECHA)
	equipar(item_inicial,0)
	pass

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()
	movimiento.mover(self, delta)
	for arma in arma_equipada:
		if arma:
			arma.procesar_fisica(delta)
	for ataque in ataques:
		if ataque:
			ataque.procesar_fisica(delta)
			pass

func obtener_arma(mano: int) -> Arma:
	if mano in Mano.values():
		return arma_equipada[mano]
	return null
	
func reemplazar_ataque(nuevo: Ataque, mano: int) -> void:
	if mano in Mano.values():
		var anterior: Ataque = ataques[mano];
		if anterior != null:
			anterior.desequipar();
		
		ataques[mano] = nuevo;
		if nuevo != null:
			nuevo.equipar(self, mano);

func obtener_otros_ataques(solicitante: Ataque) -> Array[Ataque]:
	return ataques.filter(func(a): return a != solicitante);

func atacar():
	var arma = arma_equipada[0] if (ultima_arma && arma_equipada[0]) or not arma_equipada[1] else arma_equipada[1]
	if arma:
		arma.usar()
	ultima_arma = not ultima_arma

func recibir_daño(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		morir()

func equipar(e: Equipable, slot: int) -> Equipable:
	if e is Arma and slot in [0, 1]:
		var prev_equipado = arma_equipada[slot];
		arma_equipada[slot] = e
		e.equipar(self)
		equipa_arma.emit(slot,prev_equipado, e)
		return prev_equipado
	elif e is Armadura and slot == e.obtener_slot():
		var prev_equipado = armadura_equipada[slot]
		armadura_equipada[slot] = e
		e.equipar(self)
		equipa_arma.emit(slot,prev_equipado, e)
		return prev_equipado
	return e
		
func desequipar_arma(slot: int) -> Arma:
	if slot >= 0 and slot < arma_equipada.size():
		var arma = arma_equipada[slot]
		if arma:
			arma.desequipar(self)
			arma_equipada[slot] = null
		return arma
	return null

func desequipar_armadura(slot: int) -> Armadura:
	if slot >= 0 and slot < armadura_equipada.size():
		var pieza = armadura_equipada[slot]
		if pieza:
			pieza.desequipar(self)
			armadura_equipada[slot] = null
		return pieza
	return null

func contiene_punto(punto: Vector2) -> bool:
	var hitbox: Area2D = get_node_or_null("Hitbox");
	return AreaHelper.contiene_punto(hitbox,punto);
	




func morir():
	muerte.emit()
	queue_free()


func _al_entrar_area_en_hitbox(area: Area2D) -> void:
	if area.is_in_group("enemigo") :
		print(vida)
		recibir_daño(1)
