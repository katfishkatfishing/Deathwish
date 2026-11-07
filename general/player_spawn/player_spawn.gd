class_name PlayerSpawn
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	var existing_player = get_tree().get_first_node_in_group("player")
	if existing_player:
		return
		
	spawn_player()
	
func spawn_player() -> void:
	#load in player
	var player_scene: PackedScene = load("res://player/player.tscn")
	var player_instance = player_scene.instantiate()
	
	#add player to root
	get_tree().root.add_child(player_instance)
	
	#align position
	player_instance.global_position = global_position
	
