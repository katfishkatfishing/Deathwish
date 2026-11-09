extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("bro ded")
	get_tree().reload_current_scene() #no hp n stuff yet so reload scene as death
