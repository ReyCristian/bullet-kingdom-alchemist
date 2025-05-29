extends CharacterBody2D
class_name Personaje

var nombre: String = "SinNombre"
var vida: int = 100
var arma_equipada: Array[Arma] = [null, null]
var armadura_equipada: Array[Armadura] = [null, null, null]
var ultima_arma: bool = true  # true = arma[0], false = arma[1]

signal muerte

@export var item_inicial:Equipable;

var movimiento: Movimiento = MovimientoAutomatico.new()

func _ready() -> void:
	equipar(item_inicial,0)
	pass

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play()
	movimiento.mover(self, delta)
	for arma in arma_equipada:
		if arma:
			arma.procesar_fisica(delta)
	if Input.is_action_just_pressed("shot"):
		atacar()

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
		print("equipando arma")
		var prev_equipado = arma_equipada[slot];
		arma_equipada[slot] = e
		e.equipar(self)
		return prev_equipado
	elif e is Armadura and slot == e.obtener_slot():
		print("equipando armadura")
		var prev_equipado = armadura_equipada[slot]
		armadura_equipada[slot] = e
		e.equipar(self)
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






func morir():
	muerte.emit()
	queue_free()


func _al_entrar_area_en_hitbox(area: Area2D) -> void:
	if area.is_in_group("enemigo") :
		print(vida)
		recibir_daño(1)
