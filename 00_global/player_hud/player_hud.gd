extends CanvasLayer

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar

func _ready() -> void:
	#connect to the message bus
	Messages.player_health_changed.connect(update_health_bar)
	
	#fetch initial values if player is alr loaded
	var player = get_tree()	.get_first_node_in_group("player")
	if player:
		update_health_bar(player.hp, player.max_hp)
	

func update_health_bar(current_hp: float, max_hp: float) -> void:
	# update bar
	var fill_percent: float = (current_hp / max_hp) * 100.0
	hp_bar.value = fill_percent
	
	#expand frame when max hp increase
	hp_margin_container.size.x = max_hp + 22.0
