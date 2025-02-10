extends CanvasLayer

signal start_game

func _process(delta):
	# Update the label text every frame using the global enemy kill count.
	$EnemyCountLabel.text = str(Global.enemy_kill_count)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Shoot the\nCreeps"
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()
