extends CanvasLayer

#region
@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu

@onready var new_game_button: Button = %NewGameButton
@onready var load_game_button: Button = %LoadGameButton

@onready var new_slot_01: Button = %NewSlot01
@onready var new_slot_02: Button = %NewSlot02
@onready var new_slot_03: Button = %NewSlot03

@onready var load_slot_01: Button = %LoadSlot01
@onready var load_slot_02: Button = %LoadSlot02
@onready var load_slot_03: Button = %LoadSlot03

@onready var animation_player: AnimationPlayer = $UIContainer/MainMenu/LogoContainer/AnimationPlayer
#endregion

func _ready() -> void:
	new_game_button.pressed.connect(show_new_game_menu)
	load_game_button.pressed.connect(show_load_game_menu)
	
	#hook up save creation slots
	new_slot_01.pressed.connect(on_new_game_pressed.bind(0))
	new_slot_02.pressed.connect(on_new_game_pressed.bind(1))
	new_slot_03.pressed.connect(on_new_game_pressed.bind(2))
	
	#hook up save load slots
	load_slot_01.pressed.connect(on_load_game_pressed.bind(0))
	load_slot_02.pressed.connect(on_load_game_pressed.bind(1))
	load_slot_03.pressed.connect(on_load_game_pressed.bind(2))
	
	#logo anim
	animation_player.animation_finished.connect(on_animation_finished)
	
	# default view
	show_main_menu()
	
func _unhandled_input(event: InputEvent) -> void:
	#allow backing out of submenus using escape
	if event.is_action_pressed("ui_cancel"):
		if not main_menu.visible:
			show_main_menu()

func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	new_game_button.grab_focus()
	

func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visble = false
	new_slot_01.grab_focus()
	
	new_slot_01.text = "Replace Slot 1" if SaveManager.save_file_exists(0) else "Begin Slot 1"
	new_slot_02.text = "Replace Slot 2" if SaveManager.save_file_exists(1) else "Begin Slot 2"
	new_slot_03.text = "Replace Slot 3" if SaveManager.save_file_exists(2) else "Begin Slot 3"
	
func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	new_slot_01.grab_focus()
	
	load_slot_01.disabled = not SaveManager.save_file_exists(0)
	load_slot_02.disabled = not SaveManager.save_file_exists(1)
	load_slot_03.disabled = not SaveManager.save_file_exists(2)
	
func on_new_game_pressed(slot: int) -> void:
	SaveManager.create_new_game_save(slot)
	
func on_load_game_pressed(slot: int) -> void:
	SaveManager.load_game(slot)
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "start":
		animation_player.play("loop")
