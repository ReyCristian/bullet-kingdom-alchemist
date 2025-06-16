extends Area2D
class_name SpawnEnemigo

@onready var enemigo = load("res://personajes/enemigo.tscn")
var bool_spawn = true
var nivel = 1;

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	spawn()
	
var avance = 0;
	
func spawn():
	if bool_spawn:
		$Timer.start()
		bool_spawn = false
		var enemi_instance: Enemigo = enemigo.instantiate()
		enemi_instance.position = Vector2(random.randf_range(30, 450), random.randf_range(30, 230))
		add_child(enemi_instance)
		enemi_instance.set_nivel(nivel)
		avance +=1
		if avance > 10:
			nivel += 1
			avance = 0
		



func _on_timer_timeout() -> void:
	bool_spawn = true
