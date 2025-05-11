extends CharacterBody2D

var nombre: String = "SinNombre"
var vida: int = 100
var arma_equipada: Array[Arma] = [null, null]
var armadura_equipada: Array[Armadura] = [null, null, null]
var ultima_arma: bool = true  # true = arma[0], false = arma[1]

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
	if arma and arma.esta_listo():
		arma.usar()
	ultima_arma = not ultima_arma

func recibir_daño(cantidad: int):
	vida -= cantidad
	if vida <= 0:
		morir()

func equipar(e: Equipable, slot: int):
	if e is Arma and slot in [0, 1]:
		print("es arma")
		arma_equipada[slot] = e
		e.equipar(self)
	elif e is Armadura and slot in [0, 1, 2]:
		print("es armadura")
		armadura_equipada[slot] = e
		e.equipar(self)

func morir():
	queue_free()
