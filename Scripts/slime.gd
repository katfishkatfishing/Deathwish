extends Node2D

const SPEED = 60
const CHASE_SPEED = 100
var direction = 1

var player: Node2D = null

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta):
	if player != null:
		direction = sign(player.global_position.x - global_position.x)
		
		#stop if hit wall so doesnt glitch through
		if direction == 1 and ray_cast_right.is_colliding():
			direction = 0
		elif direction == -1 and ray_cast_left.is_colliding():
			direction = 0
			
		position.x += direction * CHASE_SPEED * delta
		
		if direction != 0:
			animated_sprite_2d.flip_h = direction < 0
		
	else:
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = true
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = false
			
		position.x += direction * SPEED * delta

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
