@tool
extends Area2D

@export var beam_width: float = 4.0
@export var spawn_point: Marker2D

@onready var _start: Marker2D = $StartPoint
@onready var _end: Marker2D = $EndPoint
@onready var _line: Line2D = $Line2D
@onready var _glow_line: Line2D = $GlowLine
@onready var _collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_beam()
	_collision_shape.shape = _collision_shape.shape.duplicate()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update_beam()

func _update_beam() -> void:
	var start = _start.position
	var end = _end.position

	# Update visual lines
	_line.points = [start, end]
	_glow_line.points = [start, end]

	# Sync collision shape to match the beam
	var midpoint = (start + end) / 2.0
	var length = start.distance_to(end)
	var angle = start.angle_to_point(end)

	_collision_shape.position = midpoint
	_collision_shape.rotation = angle

	var shape = _collision_shape.shape as RectangleShape2D
	shape.size = Vector2(length, beam_width)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and spawn_point:
		body.global_position = spawn_point.global_position
