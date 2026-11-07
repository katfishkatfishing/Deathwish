class_name SavePoint
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $MessageRoot/AnimationPlayer

func _ready() -> void:
	area_2d.body_entered.connect(on_player_entered)
	area_2d.body_existed.connect(on_player_exited)

func on_player_entered(_body: Node2D) -> void:
	# show the interaction button
	Messages.input_hint_changed.emit("interact")
	
	#listen for interact key
	if not Messages.player_interacted.is_connected(on_player_interacted):
		Messages.player_interacted.connect(on_player_interacted)
		

func on_player_exited(_body: Node2D) -> void:
	#hide prompt and stop listen
	Messages.input_hint_changed.emit("")
	if Messages.player_interacted.is_connected(on_player_interacted):
		Messages.player_interacted.disconnect(on_player_interacted)

func on_player_interacted(_player: Player) -> void:
	# game saved popup
	animation_player.seek(0.0)
	animation_player.play("game_saved")
	
	#heal player
	Messages.player_healed.emit(100.0)
	
	# save
	SaveManager.save_game()
