extends CanvasLayer

signal load_scene_started
signal new_scene_ready(target_area: String, player_offset: Vector2)
signal load_scene_finished
signal scene_entered(scene_uid: String)

@onready var fade: Control = $Fade
var current_scene_uid: String = ""

func _ready() -> void:
	fade.visible = false
	#load before signal completion
	await get_tree().process_frame
	load_scene_finished.emit()
	
func transition_scene(new_scene: String, target_area:String, player_offset: Vector2, dir: String) -> void:
	load_scene_started.emit()
	
	#freeze gameplay during transition
	get_tree().paused = true
	fade.visible = true
	
	#calc swipe pos
	var fade_pos: Vector2 = get_fade_position(dir)
	
	#fade in
	await fade_screen(fade_pos, Vector2.ZERO)
	
	#swap room scene
	get_tree().change_scene_to_file(new_scene)
	await get_tree().scene_changed
	
	current_scene_uid = ResourceUID.path_to_uid(new_scene)
	scene_entered.emit(current_scene_uid)
	
	#position player at door
	new_scene_ready.emit(target_area, player_offset)
	
	#fade out
	await fade_screen(Vector2.ZERO, -fade_pos)
	
	fade.visible = false
	get_tree().paused = false
	load_scene_finished.emit()
	
func fade_screen(from: Vector2, to: Vector2) -> Signal:
	fade.position = from
	var tween: Tween = create_tween()
	tween.tween_property(fade, "position", to, 0.2)
	return tween.finished

func get_fade_position(dir: String) -> Vector2:
	var pos: Vector2 = Vector2(480.0 * 2.0, 270.0 * 2.0)
	match dir:
		"left":
			pos *= Vector2(-1.0, 0.0)
		"right":
			pos *= Vector2(1.0, 0.0)
		"up":
			pos *= Vector2(0.0, -1.0)
		"down":
			pos *= Vector2(0.0, 1.0)
	return pos
