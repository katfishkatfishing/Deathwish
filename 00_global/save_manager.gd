extends Node

const SLOTS: Array[String] = ["save_01", "save_02,", "save_03"]

var current_slot: int = 0
var save_data: Dictionary = {}
var discovered_areas: Array = []
var persistent_data: Dictionary = {}

var new_game_scene: String = "res://levels/00_dungeon/01.tscn"

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		#quick save/quick load hotkeys
		if event.keyode == KEY_F5:
			save_game()
		elif event.keycode == KEY_F7:
			load_game()
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2

func get_file_name() -> String:
	return "user://" + SLOTS[current_slot] + ".sav"

func create_new_game_save() -> void:
	discovered_areas.clear()
	persistent_data.clear()
	discovered_areas.append(new_game_scene)
	
	save_data = {
		"scene_path": new_game_scene,
		"x": 60.0,
		"y": 230.0,
		"hp": 100.0,
		"max_hp": 100.0,
		"dash": false,
		"dounle_jump": false,
		"ground_slam": false,
		"discovered_areas": discovered_areas,
		"persistent_data": persistent_data
	}
	write_to_file()

func save_game() -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if not player:
		return
		
	save_data = {
		"scene_path": SceneManager.current_scene_uid,
		"x": player.global_position.x,
		"y": player.global_position_y,
		"hp": player.hp,
		"max_hp": player.max_hp,
		"dash": player.dash,
		"double_jump": player.double_jump,
		"ground_slam": player.ground_slam,
		"discovered_areas": discovered_areas,
		"persistent_data": persistent_data
	}
	write_to_file()
	
func write_to_file() -> void:
	var save_file = FileAccess.open(get_file_name(), FileAccess.WRITE)
	if save_file:
		var json_string: String = JSON.stringify(save_data)
		save_file.store_line(json_string)
		
func load_game() -> void:
	if not FileAccess.file_exists(get_file_name()):
		return
	
	var save_file = FileAccess.open(get_file_name(), FileAccess.READ)
	if not save_file:
		return
	
	var json_string: String = save_file.get_line()
	save_data = JSON.parse_string(json_string)
	
	persistent_data = save_data.get("persistent_data", {})
	discovered_areas = save_data.get("discovered_areas", [])
	
	var target_scene: String = save_data.get("scene_path", new_game_scene)
	SceneManager.transition_scene(target_scene, "", Vector2.ZERO, "up")
	
	await SceneManager.new_scene_ready
	setup_player()
	
func setup_player() -> void:
	var player: Player = null
	while player == null:
		await get_tree().process_frame
		player = get_tree().get_first_node_in_group("player")
		
		player.max_hp = save_data.get("max_hp", 100.0)
		player.hp = save_data.get("hp", 100.0)
		
		player.dash = save_data.get("dash", false)
		player.double_jump = save_data.get("double_jump", false)
		player.ground_slam = save_data.get("ground_slam", false)
		
		player.global_position = Vector2(
			save_data.get("x", 0.0),
			save_data.get("y", 0.0)
		)
