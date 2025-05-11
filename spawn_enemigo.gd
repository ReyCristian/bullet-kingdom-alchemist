extends Area2D

@onready var Enemigo = load("res://escenas/Enemigo.tscn")
var bool_spawn = true


var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn()
	
	
func spawn():
	if bool_spawn:
		$Timer.start()
		bool_spawn = false
		var enemi_instance = Enemigo.instantiate()
		enemi_instance.position = Vector2(random.randf_range(30, 1800), random.randf_range(30, 900))
		add_child(enemi_instance)
		



func _on_timer_timeout() -> void:
	bool_spawn = true
