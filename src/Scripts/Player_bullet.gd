extends Area2D

var velocity = Vector2.ZERO
var speed = 1500.0

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	set_position(get_position() + velocity * delta)

func start_at(dir,pos):
	set_rotation(dir)
	set_position(pos)
	velocity = Vector2(speed,0).rotated(dir - PI/2)

func _on_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.get_groups().has("asteroids"):
		body.exploded(velocity.normalized())
		queue_free()
