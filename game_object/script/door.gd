extends StaticBody2D

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _occluder: LightOccluder2D = $LightOccluder2D

@export var lever_a: NodePath
@export var lever_b: NodePath

var is_open: bool = true
var _lever_states: Dictionary = {}

func _ready() -> void:
	_collision.set_deferred("disabled", true)
	_occluder.visible = false
	_sprite.animation = "open"
	_sprite.frame = _sprite.sprite_frames.get_frame_count("open") - 1

	_connect_lever(lever_a)
	_connect_lever(lever_b)
	if not _lever_states.is_empty():
		_update_dual_lever_state.call_deferred()

func _connect_lever(path: NodePath) -> void:
	if path.is_empty():
		return
	var lever = get_node(path)
	if lever == null:
		return
	_lever_states[lever] = lever.is_on
	lever.toggled.connect(_on_lever_toggled.bind(lever))

func _on_lever_toggled(is_on: bool, lever: Node) -> void:
	_lever_states[lever] = is_on
	_update_dual_lever_state()

func _update_dual_lever_state() -> void:
	if _lever_states.size() < 2:
		return
	var all_on := true
	for v in _lever_states.values():
		if not v:
			all_on = false
			break
	set_open(all_on)

func open() -> void:
	if is_open:
		return
	is_open = true
	_collision.set_deferred("disabled", true)
	_occluder.visible = false
	_sprite.play("open")

func close() -> void:
	if not is_open:
		return
	is_open = false
	_collision.set_deferred("disabled", false)
	_occluder.visible = true
	_sprite.play_backwards("open")  # rewinds the open animation as a close

func set_open(value: bool) -> void:
	if value:
		open()
	else:
		close()


func _on_pressure_plate_released() -> void:
	pass # Replace with function body.


func _on_pressure_plate_4_pressed() -> void:
	pass # Replace with function body.
