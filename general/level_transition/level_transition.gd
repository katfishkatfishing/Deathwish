@tool
class_name LevelTransition
extends Node2D

enum Side { LEFT, RIGHT, TOP, BOTTOM }

@export_range(2, 20, 1, "or_greater") var size: int = 2:
	set(value):
		size = value
		apply_area_settings()

@export var location: LevelTransition.Side = Side.LEFT:
	set(value):
		location = value
		apply_area_settings()

@export_file("*tscn") var target_level: String = ""
@export var target_area_name: String = "LevelTransition"

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	SceneManager.new_scene_ready.connect(on_new_scene_ready)
	SceneManager.load_scene_finished.connect(on_load_scene_finished)
	
func on_new_scene_ready(target_name: String, offset: Vector2) -> void:
	#only execute if door name same
	if target_name != name:
		return
	
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		player.global_position = global_position + offset
		

func on_load_scene_finished() -> void:
	#disable monitoring for 2 physics frame to prevent door loop 
	area_2d.monitoring = false
	if not area_2d.body_entered.is_connected(on_player_entered):
		area_2d.body_entered.connect(on_player_entered)
		
	await get_tree().physics_frame
	await get_tree().physics_frame
	area_2d.monitoring = true

func on_player_entered(body: Node2D) -> void:
	var offset: Vector2 = get_offset(body)
	var dir: String = get_transition_direction()
	SceneManager.transition_scene(target_level, target_area_name, offset, dir)

func get_offset(player: Node2D) -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var p_pos: Vector2 = player.global_position
	
	if location == Side.LEFT or location == Side.RIGHT:
		#save jump height relative to door bottom
		offset.y = p_pos.y - global_position.y
		offset.x = -16.0 if location == Side.LEFT else 16.0
	else:
		#save horizontal pos if transition is up/down
		offset.x = p_pos.x - global_position.x
		offset.y = -2.0 if location == Side.TOP else 48.0
	
	return offset
	
func get_transition_direction() -> String:
	match location:
		Side.LEFT:
			return "left"
		Side.RIGHT:
			return "right"
		Side.TOP:
			return "up"
		_:
			return "down"
			
func apply_area_settings() -> void:
	var a: Area2D = get_node_or_null("Area2D")
	if not a:
		return
		
	if location == Side.LEFT or location == Side.RIGHT:
		a.scale.y = size
		a.scale.x = -1.0 if location == Side.LEFT else 1.0
	else:
		a.scale.x = size
		a.scale.y = 1.0 if location == Side.TOP else -1.0
