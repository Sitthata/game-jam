extends Area2D

signal toggled(is_on: bool)

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var is_on: bool = false

@export var pan_target: Node2D
@export var pan_wait: float = 1.0
@export var pan_hold: float = 1.5
@export var pan_lantern: Node2D


var _player_in_range: bool = false

func _ready() -> void:
	_update_visual()
	toggled.emit.call_deferred(is_on)

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("interact"):
		toggle()
		get_viewport().set_input_as_handled()

func toggle() -> void:
	$SFXPlayer.play()
	is_on = !is_on
	_update_visual()
	toggled.emit(is_on)
	if is_on and pan_target != null:
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("pan_camera_to"):
			player.pan_camera_to(pan_target, pan_wait, pan_hold, pan_lantern)

func _update_visual() -> void:
	_sprite.play("on" if is_on else "off")


func set_timeline_active(active: bool) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
	if not active:
		_player_in_range = false
	for shape in find_children("*", "CollisionShape2D", true, false):
		shape.set_deferred("disabled", !active)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
