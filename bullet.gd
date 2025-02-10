extends Area2D

@export var speed = 400.0

var direction: Vector2 = Vector2(1, 0)

func _physics_process(delta):
	# Move the bullet in its direction.
	position += direction * speed * delta

	# Optionally, remove the bullet if it goes off-screen.
	var viewport_rect = get_viewport_rect()
	if position.x < -250 or position.x > viewport_rect.size.x:
		queue_free()
