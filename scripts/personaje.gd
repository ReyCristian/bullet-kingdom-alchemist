extends CharacterBody2D
const SPEED = 300.0
var direction : Vector2
#class_name personaje

# Atributos del personaje
#var nombre: String
#var vida: int
#var velocidad: float
#var arma_equipada: Arma
#armadura_equipada: armadura
#Ultima_arma: Ultima arma 
# Constructor para inicializar el personaje
#func _init(nuevo_nombre: String, nueva_vida: int, nueva_velocidad: float):
#	nombre = nuevo_nombre
#	vida = nueva_vida
#	velocidad = nueva_velocidad

# Método para mostrar información del personaje
#func mostrar_info():
#	print("Nombre: " + nombre)
#	print("Vida: " + str(vida))					
#	print("Velocidad: " + str(velocidad))
func _physics_process(delta: float) -> void:
	Move()

	pass
	
func Move():	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = direction * SPEED
	$AnimatedSprite2D.play()
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		$AnimatedSprite2D.play()  # Reproduce la animación de movimiento
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()  # Detiene la animación cuando no hay movimiento

	move_and_slide()
	pass
	
