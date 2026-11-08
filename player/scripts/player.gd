class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var oneway_platform_raycast: RayCast2D = $OnewayPlatformRaycast
@onready var move_speed: float = 150.0
@onready var max_fall_velocity: float = 600.0

const DEBUG_JUMP_INDICATOR = preload("res://player/debug_jump_indicator.tscn")

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
var gravity_multiplier: float = 1.0

#region //player stats
var hp: float = 100.0:
	set(value):
		hp = clampf(value, 0.0, max_hp)
		Messages.player_health_changed_emit(hp, max_hp)

var max_hp: float = 100.0:
	set(value):
		max_hp = maxf(value, 1.0)
		Messages.player_health_changed.emit(hp, max_hp)
		

var dash: bool = false
var double_jump: bool = false
var ground_slam: bool = false
#endregion

func _ready() -> void:
	#if player instance already persists, free the dupe
	var existing_player = get_tree().get_first_node_in_group("player")
	if existing_player and existing_player != self:
		queue_free()
		return
		
	#reparent so wont get deleted when scene change
	reparent.call_deferred(get_tree().root)
	
	Messages.player_healed.connect(on_player_healed)
	
	initialise_states()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
		
	change_state(current_state.handle_input(event))

func _process(delta: float) -> void:
	update_direction()
	change_state(current_state.process(delta))
	
func _physics_process(delta: float) -> void:
	#apply gravity to jump
	velocity.y += (gravity * gravity_multiplier) * delta
	
	velocity.y = clampf(velocity.y, -1000.0, max_fall_velocity)
	
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
	if new_state == null or new_state == current_state:
		return
		
	#exit old state
	if current_state:
		current_state.exit()
		
	#push the new state to idx 0 and enter it
	states.push_front(new_state)
	current_state.enter()

	#keep history at 3 to prevent bloat
	states.resize(3)
	
	#update label for debug
	$Label.text = current_state.name
	
func update_direction() -> void:
	#in case there are ever any players playing with controller
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	

func add_debug_indicator(color: Color = Color.RED) -> void:
	var d: Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	
	await get_tree().create_timer(3.0).timeout
	d.queue_free()

func on_player_healed(amount: float) -> void:
	hp = min(hp + amount, max_hp)
