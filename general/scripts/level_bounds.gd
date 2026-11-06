@tool
class_name LevelBounds
extends Node2D

@export_range(480, 2048, 32, "suffix:px") var width: int = 480:
	set = on_width_changed
@export_range(270, 2048, 32, "suffix:px") var height: int = 270:
	set = on_height_changed

func _ready() -> void:
	#edit mdoe
	if Engine.is_editor_hint():
		z_index = 256
		return
	
	#game mode
	var camera: Camera2D = null
	while camera == null:
		await get_tree().process_frame
		camera = get_viewport().get_camera_2d()
		
	#limit camera
	camera.limit_left = int(global_position.x)
	camera.limit_right = int(global_position.x) + width
	camera.limit_top = int(global_position.y)
	camera.limit_bottom = int(global_position.y) + height
	
func _draw() -> void:
	# only render box inside editor
	if Engine.is_editor_hint():
		var r: Rect2 = Rect2(Vector2.ZERO, Vector2(width, height))
		
		draw_rect(r, Color(0.0, 0.45, 1.0, 0.6), false, 3.0)
		draw_rect(r, Color(0.0, 0.75, 1.0, 1.0), false, 1.0)
		
		
func on_width_changed(new_width: int) -> void:
	width = new_width
	queue_redraw()
	
func on_height_changed(new_height: int) -> void:
	height = new_height
	queue_redraw()
