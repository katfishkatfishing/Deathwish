class_name PlayerStateRun
extends PlayerState

@export var move_speed: float = 100.0

func handle_input(event: InputEvent) -> PlayerState:
	#run n jump
	if event.is_action_pressed("jump"):
		return jump
	return next_state

func process(_delta: float) -> PlayerState:
	if player.direction.x == 0.0:
		return idle
	elif player.direction.y >= 0.5:
		return crouch
	return next_state

func physics_process(_delta: float) -> PlayerState:
	#fall if run til floor gon
	if not player.is_on_floor():
		return fall
	
	#apply x movement based on speed
	player.velocity.x = player.direction.x * move_speed
	return next_state
