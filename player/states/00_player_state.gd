class_name PlayerState
extends Node

var player: Player
var next_state: PlayerState

func init() -> void:
	pass

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state

func process(_delta: float) -> PlayerState:
	return next_state

func physics_update(_delta: float) -> void:
	pass
