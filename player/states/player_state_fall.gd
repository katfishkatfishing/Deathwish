class_name PlayerStateFall
extends PlayerState

@export var coyote_time: float = 0.125
@export var jump_buffer_time: float = 0.2
@export var fall_gravity_multiplier: float = 1.65

var coyote_timer: float = 0.0
var buffer_timer: float = 0.0

func enter() -> void:
	#increase grav when falling for smoother
	player.gravity_multiplier = fall_gravity_multiplier
	
	#only coyote timme if walk off edge
	if player.previous_state == jump:
		coyote_timer = 0.0
	else:
		coyote_timer = coyote_time
		
func exit() -> void:
	#reset grav mult when land
	player.gravity_multiplier = 1.0
	
func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		#so that can jump even if a lil off the edge
		if coyote_timer > 0.0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state
	
func process(delta: float)  -> PlayerState:
	# count down timers every frame
	coyote_timer -= delta
	buffer_timer -= delta
	return next_state

func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		
		if buffer_timer > 0.0:
			return jump

		return idle
		
	#air control while falling
	player.velocity.x = player.direction.x * player.move_speed
	
	return next_state
