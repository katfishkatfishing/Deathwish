extends RigidBody2D

@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var is_triggered: bool = false

func _ready() -> void:
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	
# connects the Area2D's body_entered signal to this function
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Something touched the platform: ", body.name)
	if not is_triggered and body is Player:
		print("Player detected! Starting timer...")
		is_triggered = true
		timer.start()

# connects Timer's timeout signal to this function
func _on_timer_timeout() -> void:
	collision_shape.one_way_collision = false
	freeze = false
