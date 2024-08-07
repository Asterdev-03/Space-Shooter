extends Area2D

@export var rot_speed = 2.6
@export var thrust = 500
@export var max_vel = 400
@export var friction = 0.65
@export var bullet_scene:PackedScene

@onready var bullet_container = $Bullet_container
@onready var gun_timer = $Gun_timer

var screen_size = Vector2.ZERO
var rot = 0.0
var pos = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_position(pos)
	set_process(true)

func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("right"):
		rot += rot_speed * delta
	
	if Input.is_action_pressed("shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()
	
	if Input.is_action_pressed("thrust"):
		acceleration = Vector2(thrust,0).rotated(rot)
	else:
		acceleration = Vector2.ZERO
	
	acceleration += velocity * -friction
	
	#warp around screen edges
	if pos.x > screen_size.x:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.x
	if pos.y > screen_size.y:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.y
	
	velocity += acceleration * delta
	pos += velocity * delta
	set_position(pos)
	set_rotation(rot + PI/2)

func shoot():
	gun_timer.start()
	var bullet = bullet_scene.instantiate()
	bullet_container.add_child(bullet)
	bullet.start_at(get_rotation(),get_node("Muzzle").get_global_position())


