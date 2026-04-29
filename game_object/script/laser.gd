@tool
extends Node2D

@export var beam_width: float = 4.0
@export var beam_length: float = 300.0
@export var beam_glow_spread: float = 8.0
@export var spawn_point: Marker2D

@onready var _line: Line2D = $Line2D
@onready var _glow_line: Line2D = $GlowLine
@onready var _area: Area2D = $Area2D
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _hit_particles: GPUParticles2D = $HitParticles
@onready var _flare: GPUParticles2D = $Flare
@onready var _emitter_light: PointLight2D = get_node_or_null("EmitterLight")
@onready var _hit_light: PointLight2D = get_node_or_null("HitLight")
@onready var _beam_light: PointLight2D = get_node_or_null("BeamLight")
var _active: bool = true

# Base half-size of the PointLight2D texture at texture_scale=1.
# Tune this to match your light texture's natural radius (default Godot circle = 64px).
const BEAM_LIGHT_BASE_HALF := 64.0

var _exclude_rids: Array[RID] = []

func set_active(active: bool) -> void:
	_active = active
	_line.visible = active
	_glow_line.visible = active
	_area.monitoring = active
	if _emitter_light: _emitter_light.enabled = active
	if _beam_light: _beam_light.enabled = active
	if not active:
		_line.points = []
		_glow_line.points = []
		_hit_particles.emitting = false
		_flare.emitting = false
		if _hit_light: _hit_light.enabled = false

func _ready() -> void:
	_collision_shape.shape = _collision_shape.shape.duplicate()

	if not Engine.is_editor_hint():
		for node in get_tree().get_nodes_in_group("player"):
			if node is CollisionObject2D:
				_exclude_rids.append(node.get_rid())

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if not _line or not _glow_line:
			return
	if _active:
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
			_hit_particles.position = end_local
			_hit_particles.emitting = true
			_flare.position = end_local
			_flare.emitting = true
			if _hit_light:
				_hit_light.position = end_local
				_hit_light.enabled = true
		else:
			end_local = Vector2(beam_length, 0)
			_hit_particles.emitting = false
			_flare.emitting = false
			if _hit_light: _hit_light.enabled = false
	else:
		end_local = Vector2(beam_length, 0)
		_hit_particles.emitting = false
		_flare.emitting = false
		if _hit_light: _hit_light.enabled = false

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

	# Scale beam light to match actual beam rectangle (length × beam_width)
	if _beam_light and _beam_light.texture:
		var tex := _beam_light.texture.get_size() * _beam_light.texture_scale
		_beam_light.position = midpoint
		_beam_light.rotation = end_local.angle()
		_beam_light.scale = Vector2(length * 1.7 / tex.x, (beam_width * beam_glow_spread) / tex.y)

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and spawn_point:
		do_death_and_respawn(body)

func do_death_and_respawn(player: Node2D) -> void:
	player.do_play_death(func():
		player.global_position = spawn_point.global_position
	)


func _on_pressure_plate_7_pressed() -> void:
	pass # Replace with function body.
