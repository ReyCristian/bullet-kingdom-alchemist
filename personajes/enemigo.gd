extends Personaje
class_name Enemigo

const SPEED = 150

var personaje = null

func _ready() -> void:
	personaje = get_tree().get_nodes_in_group("personaje")[0]

func _physics_process(_delta):
	if personaje:
		var direction = (personaje.global_position - global_position).normalized()
		velocity = direction * SPEED
		#$AnimatedSprite2D2.play()
		if direction.x > 0:
			$AnimationPlayer.play("derecha")
		else:
			$AnimationPlayer.play("izquierda")
		move_and_slide()

	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		morir()
