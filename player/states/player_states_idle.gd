class_name PlayerStateIdle
extends PlayerState

func enter() -> void:
	#when idle stopp movemment
	player.velocity.x = 0.0
	
func physics_process(_delta: float) -> PlayerState:
	#inpupt transition to run
	if player.direction.x != 0.0:
		return player.get_node("States/Run")
	
	return next_state
