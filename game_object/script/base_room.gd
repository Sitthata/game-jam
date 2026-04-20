extends Node2D

func set_timeline(is_present: bool) -> void:
	var present_node := get_node_or_null("Present")
	var past_node    := get_node_or_null("Past")
	if present_node:
		_set_side_active(present_node, is_present)
	if past_node:
		_set_side_active(past_node, !is_present)

func _set_side_active(side: Node2D, active: bool) -> void:
	side.visible = active
	for child in side.get_children():
		if child is TileMapLayer:
			child.collision_enabled = active
		else:
			child.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
			for shape in child.find_children("*", "CollisionShape2D", true, false):
				shape.set_deferred("disabled", !active)
			if child.has_method("set_timeline_active"):
				child.set_timeline_active(active)
