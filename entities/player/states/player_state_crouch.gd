class_name PlayerStateCrouch
extends PlayerState

@export var deceleration_rate: float = 10.0

func enter() -> void:
	#swap collision shape to crouching
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.sprite.play("Crouch(" + player.facing_direction + ")")
	
	#temp visuals
	player.sprite.scale.y = 0.625
	player.sprite.position.y = -15.0
	
func exit() -> void:
	#back to stand
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true

	#temp visuals 2
	player.sprite.scale.y = 1.0
	player.sprite.position.y = -24

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		#if on oneway platform, drop down
		if player.oneway_platform_raycast.is_colliding():
			player.position.y += 4.0
			return fall
			#if on regular ground, normal jump
		else:
			return jump
	return next_state
	
func process(_delta: float) -> PlayerState:
	#release down key -> return to idle
	if player.direction.y < 0.5:
		return idle
	return next_state
	
func physics_process(delta: float) -> PlayerState:
	# fall if platform gone
	if not player.is_on_floor():
		return fall
		
	#update facing directions while crouched
	if player.direction.x > 0:
		player.facing_direction = "Right"
		player.sprite.play("Crouch(Right)")
	elif player.direction.x < 0:
		player.facing_direction = "Left"
		player.sprite.play("Crouch(Left)")
		
	#decel when crouching
	player.velocity.x -= (player.velocity.x * deceleration_rate) * delta
	
	return next_state
