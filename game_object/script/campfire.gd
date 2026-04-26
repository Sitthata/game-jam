extends Node2D

@export var is_active: bool = false
@export var spawn_offset: Vector2 = Vector2(0, -16)

@onready var campfire_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	campfire_sprite.play("flame")
	add_to_group("respawn_point")

func activate() -> void:
	is_active = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_active:
		activate()
		print("Save point check")
