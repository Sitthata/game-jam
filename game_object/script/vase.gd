# vase.gd
extends CharacterBody2D

signal landed_on_plate  # emitted when vase enters a plate Area2D
signal lifted_from_plate

func push(direction: Vector2, push_speed: float) -> void:
	velocity = direction * push_speed
	move_and_slide()
	velocity = Vector2.ZERO  # stop after one frame push


func _on_pressure_plate_pressed() -> void:
	pass # Replace with function body.
