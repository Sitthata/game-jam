@tool
extends Node2D

@export var beam_width: float = 4.0
@export var beam_length: float = 300.0
@export var spawn_point: Marker2D

@onready var _line: Line2D = $Line2D
@onready var _glow_line: Line2D = $GlowLine
@onready var _area: Area2D = $Area2D
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var _exclude_rids: Array[RID] = []

func _ready() -> void:
	_collision_shape.shape = _collision_shape.shape.duplicate()

	if not Engine.is_editor_hint():
		for node in get_tree().get_nodes_in_group("player"):
			_exclude_rids.append(node.get_rid())

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if not _line or not _glow_line:
			return
	_update_beam()

func _update_beam() -> void:
	var from = global_position
	var to = from + Vector2(beam_length, 0).rotated(global_rotation)

	var end_local: Vector2

	var space_state = get_world_2d().direct_space_state
	if space_state:
		var query = PhysicsRayQueryParameters2D.create(from, to)
		query.collision_mask = 3
		query.collide_with_bodies = true
		query.exclude = _exclude_rids

		var result = space_state.intersect_ray(query)
		if result:
			end_local = to_local(result.position)
		else:
			end_local = Vector2(beam_length, 0)
	else:
		end_local = Vector2(beam_length, 0)

	# Visual
	_line.points = [Vector2.ZERO, end_local]
	_glow_line.points = [Vector2.ZERO, end_local]

	# Sync collision shape to cover the beam
	var length = end_local.length()
	var midpoint = end_local / 2.0

	_collision_shape.position = midpoint
	_collision_shape.rotation = end_local.angle()

	var shape = _collision_shape.shape as RectangleShape2D
	shape.size = Vector2(length, beam_width)

func _on_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and spawn_point:
		body.global_position = spawn_point.global_position
