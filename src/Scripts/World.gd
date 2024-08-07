extends Node

@onready var asteroid_scene = preload("res://src/Objects/Asteroids.tscn")
@onready var explosion = preload("res://src/Objects/Explosion.tscn")
@onready var spawns = get_node("Spawn_locations")
@onready var asteroid_container = get_node("Asteroid_container")

var break_pattern = {'big': 'med',
					'med': 'small',
					'small': 'tiny',
					'tiny': null}

func _ready() -> void:
	for i in range(1):
		spawn_asteroid("big",spawns.get_child(i).get_position(),Vector2.ZERO)
	set_process(true)

func _process(_delta: float) -> void:
	if asteroid_container.get_child_count() == 0:
		for i in range(2):
			spawn_asteroid("big",spawns.get_child(i).get_position(),Vector2.ZERO)

func spawn_asteroid(size,pos,vel):
	var asteroid = asteroid_scene.instantiate()
	asteroid_container.add_child(asteroid)
	asteroid.connect("explode", Callable(self, "explode_asteroid"))
	asteroid.init(size,pos,vel)

func explode_asteroid(size,pos,vel,hit_vel):
	var new_size = break_pattern[size]
	if new_size:
		for offset in [-1,1]:
			var new_pos = pos + hit_vel.orthogonal().limit_length(25) * offset
			var new_vel = vel * hit_vel.orthogonal() * offset
			spawn_asteroid(new_size,new_pos,new_vel)
	var expl = explosion.instantiate()
	add_child(expl)
	expl.set_position(pos)
	expl.play()


