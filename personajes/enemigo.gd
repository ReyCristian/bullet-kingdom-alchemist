extends Personaje
class_name Enemigo

const SPEED = 150

var personaje = null

func _ready() -> void:
	personaje = get_tree().get_nodes_in_group("personaje")[0]

func _physics_process(delta):
	if personaje:
		var direction = (personaje.global_position - global_position).normalized()
		velocity = direction * SPEED
		$AnimatedSprite2D2.play()
		move_and_slide()


	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		queue_free()
