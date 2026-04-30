extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	SceneTransition.change_scene("res://game_object/scene/ending_scene.tscn")
