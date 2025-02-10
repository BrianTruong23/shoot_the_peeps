extends Node

@export var mob_scene: PackedScene

var score

var score_count


func _ready():
	var nodes_to_hide = [$SafeZone, $Wall, $Wall2, $Wall4, $Wall5, $Wall6, $Boxes]
	for node in nodes_to_hide:
		node.hide()
	

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	mob.name = "Mob_" + str(mob.get_instance_id())  # Unique name but still identifiable

	# Choose a random location on Path2D.
	#var mob_spawn_location = $MobPath/MobSpawnLocation
	
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func new_game() -> void:
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	Global.enemy_kill_count = 0
	$Player.is_game_running = true 
	
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$SafeZone.show()
	$Wall.show()
	$Wall2.show()
	$Wall4.show()
	$Wall5.show()
	$Wall6.show()
	$Boxes.show()



func game_over() -> void:
	$Player.is_game_running = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
