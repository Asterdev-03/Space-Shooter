extends CharacterBody2D

signal explode

var size
var vel = Vector2.ZERO
var rot_speed = Vector2.ZERO
var screen_size = Vector2.ZERO
var extents = Vector2.ZERO
#var bounce = 105.0
var textures = {'big': ["res://src/Assets/Meteors/meteorGrey_big1.png",
						"res://src/Assets/Meteors/meteorGrey_big2.png",
						"res://src/Assets/Meteors/meteorGrey_big3.png",
						"res://src/Assets/Meteors/meteorGrey_big4.png"],
				'med': ["res://src/Assets/Meteors/meteorGrey_med1.png",
						"res://src/Assets/Meteors/meteorGrey_med2.png"],
				'small': ["res://src/Assets/Meteors/meteorGrey_small1.png",
						"res://src/Assets/Meteors/meteorGrey_small2.png"],
				'tiny': ["res://src/Assets/Meteors/meteorGrey_tiny1.png",
						"res://src/Assets/Meteors/meteorGrey_tiny2.png"],
				}

func _ready() -> void:
	randomize()
	add_to_group("asteroids")
	set_physics_process(true)
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	vel = vel.limit_length(300)
	set_rotation(get_rotation() + rot_speed * delta)
	move_and_collide(vel * delta)
	
	#if is_colliding():
		#vel += get_collision_normal() * (get_collider().vel.length() * bounce)
	
	#warp around screen edges
	var pos = get_position()
	if pos.x > screen_size.x + extents.x:
		pos.x = -extents.x
	if pos.x < -extents.x:
		pos.x = screen_size.x + extents.x
	if pos.y > screen_size.y + extents.y:
		pos.y = -extents.y
	if pos.y < -extents.y:
		pos.y = screen_size.y + extents.y
	set_position(pos)

func init(init_size,init_pos,init_vel):
	size = init_size
	
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(randf_range(50,100),0).rotated(randf_range(0,2 * PI))
		
	rot_speed = randf_range(-1.5,1.5)
	
	var texture = load(textures[size][randi() % textures[size].size()])
	get_node("Sprite2D").set_texture(texture)
	extents = texture.get_size() / 2
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.set_radius(min(texture.get_width()/2,texture.get_height()/2))
	add_child(collision)
	collision.set_deferred("shape",shape)
	#collision.shape = shape
	set_position(init_pos)

func exploded(hit_vel):
	emit_signal("explode",size,get_position(),vel,hit_vel)
	queue_free()


