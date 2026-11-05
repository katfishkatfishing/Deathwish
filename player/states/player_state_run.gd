class_name PlayerStateRun
extends PlayerState

@export var move_speed: float = 100.0

func physics_process(_delta: float) -> PlayerState:
	#if movement inputs released, go back to idle
	if player.direction.x == 0.0:
		return player.get_node("States/Idle")
		
	#apply x movement based on speed
	player.velocity.x = player.direction.x * move_speed
	
	return next_state
