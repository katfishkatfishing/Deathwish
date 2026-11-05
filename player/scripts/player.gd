class_name Player
extends CharacterBody2D

# state machine variables
var states: Array[PlayerState] = []

# return active state
var current_state: PlayerState:
	get:
		return states.front()
		
#return immediate previous state
var previous_state: PlayerState:
	get:
		return states[1]
		
#variables
var direction: Vector2 = Vector2.ZERO
var gravity: float = 980.0

func _ready() -> void:
	initialise_states()
	
func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))
	
func _physics_process(delta: float) -> void:
	#apply gravity to jump
	velocity.y += gravity * delta
	
	#execute movement & collisions
	move_and_slide()
	
	#allow current state to run physics ticks or trigger transitions
	change_state(current_state.physics_process(delta))

func initialise_states() -> void:
	states.clear()
	
	#find all child nodes that inherit from PlayerState
	for child in $States.get_children():
		if child is PlayerState:
			states.append(child)
			child.player = self
			
	if states.size() == 0:
		return
		
	# run initial setup on each state
	for state in states:
		state.init()
		
	#enter default start state (idle)
	change_state(current_state)
	current_state.enter()

func change_state(new_state: PlayerState) -> void:
	#if no transition requested or already in that state, ignore
	if new_state == null:
		return
	elif new_state == current_state:
		return
		
	#exit old state
	if current_state:
		current_state.exit()
		
	#puah the new state to idx 0 and enter it
	states.push_front(new_state)
	current_state.enter()

	#keep hiatory at 3 to prevent bloat
	states.resize(3)
	
func update_direction() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
