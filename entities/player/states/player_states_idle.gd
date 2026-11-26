class_name PlayerStateIdle
extends PlayerState

func enter() -> void:
	#when idle stopp movemment
	player.velocity.x = 0.0
	player.sprite.play("Idle(" + player.facing_direction + ")")
	
func handle_input(event: InputEvent) -> PlayerState:
	#jumpp when stationary
	if event.is_action_pressed("jump"):
		return jump
	return next_state

func process(_delta: float) -> PlayerState:
	#transition to run if input
	if player.direction.x != 0.0:
		return run
	elif player.direction.y >= 0.5:
		return crouch
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	#fall if floor gon
	if not player.is_on_floor():
		return fall
	#make sure velo is 0
	player.velocity.x = 0.0
	#continuously update player facing direction
	player.sprite.play("Idle(" + player.facing_direction + ")")
	return next_state
