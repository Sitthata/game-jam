@tool
extends Node2D

@export var is_active: bool = false
@export var spawn_offset: Vector2 = Vector2(0, -16)
@export var detection_radius: float = 32.0:
	set(value):
		detection_radius = value
		if is_node_ready():
			_apply_radius()

@onready var campfire_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _detection_shape: CollisionShape2D = $DetectionArea/CollisionShape2D

func _ready() -> void:
	_apply_radius()
	if Engine.is_editor_hint():
		return
	campfire_sprite.play("flame")
	add_to_group("respawn_point")
	$SFXPlayer.play()

func _apply_radius() -> void:
	var shape := _detection_shape.shape.duplicate() as CircleShape2D
	shape.radius = detection_radius
	_detection_shape.shape = shape

func activate() -> void:
	is_active = true

func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or is_active:
		return
	activate()
	var displays := get_tree().get_nodes_in_group("hint_display")
	if displays.is_empty():
		return
	displays[0].show_hint("Checkpoint Reached", 1.5)
