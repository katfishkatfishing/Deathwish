class_name PlayerStateJump
extends PlayerState

@export var jump_velocity: float = 450.0

func enter() -> void:
	#upward impulse
	player.velocity.y = -jump_velocity #uh up is - forsomereason
	player.add_debug_indicator(Color.LIME_GREEN)
	
func exit() -> void:
	#debug use
	player.add_debug_indicator(Color.YELLOW)
	
func handle_input(event: InputEvent) -> PlayerState:
	#jump height, if let go of jump early then jump weak
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	#once vertical stops increasing, change to fall
	if player.velocity.y >= 0.0:
		return fall
	elif player.is_on_floor():
		return idle
		
	#air control
	player.velocity.x = player.direction.x * player.move_speed
	
	return next_state
