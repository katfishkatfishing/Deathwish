class_name InputHints
extends Node2D

# map button actions to the icon
const HINT_MAP: Dictionary = {
	"interact": "action", # S
	"attack": "attack", # X
	"jump": "jump", # Z
	"dash": "dash", # C
	"up": "up"
}

const CONTROLLER_ACTION: Dictionary = {
	"playstation": {
		"interact": "Triangle",#triangle
		"jump": "Cross", #cross
		"attack": "Square", #square
		"dash": "Circle", #circle
		"up": "Up"
	},
	"xbox": {
		"interact": "Y", # Y
		"jump": "A", # A
		"attack": "X", # X
		"dash": "B", # B
		"up": "Up"
	}
}

var controller_type: String = "keyboard"
@onready var label: Label = $Label

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
	if controller_type == "keyboard":
		label.text = "[" + get_keyboard_key(hint) + "]"
	else:
		var current_map: Dictionary = CONTROLLER_ACTION.get(controller_type, CONTROLLER_ACTION["xbox"])
		label.text = "[" + current_map.get(hint, "?") + "]"

func get_keyboard_key(hint: String) -> String:
	var action_name: String = HINT_MAP.get(hint, hint)
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode if event.physical_keycode != 0 else event.keycode)
	return action_name.to_upper()
