# vase.gd
extends CharacterBody2D

signal landed_on_plate  # emitted when vase enters a plate Area2D
signal lifted_from_plate

func push(direction: Vector2, push_speed: float) -> void:
	velocity = direction * push_speed
	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider and collider.has_method("push"):
			collider.push(col.get_normal() * -1, push_speed)
	velocity = Vector2.ZERO
