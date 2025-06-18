extends CharacterBody2D
class_name Personaje

var nombre: String = "SinNombre"
@export var vida: int = -1
var arma_equipada: Array[Arma] = [null, null]
var armadura_equipada: Array[Armadura] = [null, null, null]
enum Mano { IZQUIERDA, DERECHA }
var ultima_arma: bool = true  # true = arma[0], false = arma[1]
var vida_actual: int
@onready var barra_vida: Control=$BarraVida


signal muerte
signal equipa_armadura(slot:int,prev:Armadura, nuevo:Armadura)
signal equipa_arma(slot:int,prev:Arma, nuevo:Arma)

@export var item_inicial:Equipable;

var movimiento: Movimiento = MovimientoAutomatico.new()
var ataques: Array[Ataque]= [AtaqueAutomatico.new((1 << 1)),AtaqueAutomatico.new((1 << 1) | (1 << 1))]

var nivel:int = 1

var atributos:Dictionary = {}

func _ready() -> void:
	ataques[Mano.IZQUIERDA].equipar(self,Mano.IZQUIERDA)
	ataques[Mano.DERECHA].equipar(self,Mano.DERECHA)
	equipar(item_inicial,0)
	vida_actual = vida
#	crear_barra_vida()
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

func recibir_daño(daño: Daño):
	daño.atributos_defendente = _calcular_atributos()
	marcar_daño(daño)
	vida_actual -= daño.calcular()
	if vida_actual <= 0:
		morir()

func equipar(e: Equipable, slot: int) -> Equipable:
	if e is Arma and slot in [0, 1]:
		var prev_equipado:Arma = desequipar_arma(slot);
		arma_equipada[slot] = e
		e.equipar(self)
		equipa_arma.emit(slot,prev_equipado, e)
		_calcular_atributos()
		return prev_equipado
	elif e is Armadura and slot == e.obtener_slot():
		var prev_equipado:Armadura = desequipar_armadura(slot)
		armadura_equipada[slot] = e
		e.equipar(self)
		equipa_arma.emit(slot,prev_equipado, e)
		_calcular_atributos()
		return prev_equipado
	return e
		
func desequipar_arma(slot: int) -> Arma:
	if slot >= 0 and slot < arma_equipada.size():
		var arma = arma_equipada[slot]
		if arma:
			arma.desequipar(self)
			arma_equipada[slot] = null
			_calcular_atributos()
		return arma
	return null

func desequipar_armadura(slot: int) -> Armadura:
	if slot >= 0 and slot < armadura_equipada.size():
		var pieza = armadura_equipada[slot]
		if pieza:
			pieza.desequipar(self)
			armadura_equipada[slot] = null
			_calcular_atributos()
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
		recibir_daño(Daño.new(1))
		print(vida_actual)

func set_nivel(_nivel:int):
	nivel = _nivel
	
func marcar_daño(daño: Daño) -> void:
	var label_original: Label = $Control/Label
	var label: Label = label_original.duplicate()
	var contenedor: Control = $Control
	get_parent().add_child(label)

	var area: Vector2 = contenedor.get_size()
	var posicion_aleatoria: Vector2 = Vector2(
		randi_range(0,area.x),
		randi_range(0,area.y)
	)
	label.position = posicion_aleatoria + global_position 

	label.text = str(daño)
	label.visible = true
	label.modulate = Color.GOLD if daño.esCritico else Color.WHITE
	label.set_z_index(999)
	
	var tween: Tween = get_tree().create_tween()
	var duracion: float = 0.8
	var desplazamiento: Vector2 = Vector2(0, -40)

	tween.tween_property(label, "modulate:a", 0.0, duracion)
	tween.parallel().tween_property(label, "position", label.position + desplazamiento, duracion)
	tween.tween_callback(Callable(label, "queue_free"))

func _calcular_atributos() -> Dictionary:
	var acumulado: Dictionary = {}

	for arma in arma_equipada:
		if arma != null:
			for atributo:Atributo in arma.atributos:
				Atributo.agregar_en(acumulado,atributo)

	for armadura in armadura_equipada:
		if armadura != null:
			for atributo in armadura.atributos:
				Atributo.agregar_en(acumulado,atributo)
	
	atributos = acumulado
	return acumulado

func get_atributos() -> Dictionary:
	return atributos;

func descripcion() -> String:
	var texto := "[center]Personaje[/center]"
	var totales := _calcular_atributos()

	if totales.is_empty():
		return texto + "\n[font_size=6]Sin atributos equipados[/font_size]"

	texto += "\n[font_size=6]"
	for tipo in totales.keys():
		var nombre :String= Atributo.NombresTipo.get(tipo, "¿?")
		var atributo :Atributo= totales[tipo]
		var color := Item.color_por_rareza(Item.Rareza.comun)  # o algo más dinámico si querés
		texto += "\n"+ atributo.descripcion()
	texto += "[/font_size]"
	return texto

#func crear_barra_vida():
#	var escena_barra = $BarraVida
#	barra_vida = escena_barra.instantiate()
#	get_parent().add_child(barra_vida)
#	barra_vida.position = self.global_position + Vector2(0, -40)  # encima del personaje
#	barra_vida.visible = false  # Se muestra solo al recibir daño

func actualizar_barra_vida():
	if barra_vida: #and barra_vida.has_node("ProgressBar"):
#		var barra = barra_vida.get_node("ProgressBar")
		barra_vida.value = float(vida_actual) / float(vida) * 100.0
		barra_vida.visible = true

#func _process(delta):
#	if barra_vida:
#		barra_vida.position = self.global_position + Vector2(0, -40)
