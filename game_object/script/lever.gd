extends Area2D

signal toggled(is_on: bool)

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var is_on: bool = false


var _player_in_range: bool = false

func _ready() -> void:
	_update_visual()

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("interact"):
		toggle()
		get_viewport().set_input_as_handled()

func toggle() -> void:
	is_on = !is_on
	_update_visual()
	toggled.emit(is_on)

func _update_visual() -> void:
	_sprite.play("on" if is_on else "off")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		print("In Range")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		print("Out Range")
