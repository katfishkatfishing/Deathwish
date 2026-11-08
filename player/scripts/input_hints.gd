class_name InputHints
extends Node2D

# map button actions to the icon
const HINT_MAP: Dictionary = {
	"keyboard": {
		"interact": 12, # S
		"attack": 10, # X
		"jump": 9, # Z
		"dash": 11, # C
		"up": 13
	},
	"playstation": {
		"interact": 0,#triangle
		"jump": 1, #cross
		"attack": 2, #square
		"dash": 3, #circle
		"up": 4
	},
	"xbox": {
		"interact": 8, # Y
		"jump": 5, # A
		"attack": 7, # X
		"dash": 6, # B
		"up": 4
	}
}

var controller_type: String = "keyboard"
@onready var sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect(on_hint_changed)
	
func _input(event: InputEvent) -> void:
	# detect mosue/keyboard input
	if event is InputEventKey or event is InputEventMouseButton:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		get_controller_type(event.device)
		
func get_controller_type(device_id: int) -> void:
	var joy_name: String = Input.get_joy_name(device_id).to_lower()
	if "xbox" in joy_name:
		controller_type = "xbox"
	elif "playstation" in joy_name or "ps" in joy_name or "dual" in joy_name:
		controller_type = "playstation"
	else:
		controller_type = "xbox" #third party prob use these right

func on_hint_changed(hint: String) -> void:
	if hint == "":
		visible = false
		return
		
	visible = true
	var current_map: Dictionary = HINT_MAP.get(controller_type, HINT_MAP["keyboard"])
	sprite_2d.frame = current_map.get(hint, 0)
