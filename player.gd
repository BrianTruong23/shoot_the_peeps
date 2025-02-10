extends CharacterBody2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var facing_direction: Vector2 = Vector2(1, 0)  # Default to facing right.
var is_game_running = true  # Default to true at the start of the game

func _ready():
	screen_size = get_viewport_rect().size
	hide()

	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
		facing_direction = Vector2(1, 0)  # Facing right.
	if Input.is_action_pressed("move_left"):
		facing_direction = Vector2(-1, 0)  # Facing right.
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized() * speed
		velocity = input_vector

	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Flip sprite based on direction
	var sprite = $Area2D/AnimatedSprite2D
	if input_vector.x < 0:
		sprite.flip_h = true
	elif input_vector.x > 0:
		sprite.flip_h = false

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
	
# Detect collision with enemies
func _on_body_entered(_body):
	if _body.name.begins_with("Mob"):
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		
	if _body.name.begins_with("Boxes"):
		var push_strength = 100  # Adjust this value to control push force
		_body.apply_central_impulse(facing_direction * push_strength)

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot_bullet()
		
func shoot_bullet():
	if not is_game_running:  # Prevent shooting bullets if the game is over
		return
		
	# Load the bullet scene and create an instance.
	var bullet_scene = preload("res://bullet.tscn")
	var bullet = bullet_scene.instantiate()

	# Flip the bullet's sprite if the player is facing left; otherwise ensure it isn't flipped.
	if facing_direction == Vector2(-1, 0):
		bullet.get_node("Sprite2D").flip_h = true
		
	print("Player position: ", global_position)
	
	# Define an offset: for example, 100 pixels left and 100 pixels down.
	# (You can adjust these numbers as needed.)
	var offset = Vector2(-130, -140)

	# Set the bullet's global position to the player's position plus the offset.
	bullet.global_position = global_position + offset

	# Print the bullet's global position.
	print("Bullet position: ", bullet.global_position)

	# Set the bullet's direction based on the player's current facing direction.
	bullet.direction = facing_direction

	# Add the bullet to the scene tree so it becomes active in the game.
	get_parent().add_child(bullet)
