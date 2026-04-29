extends Node2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _light: PointLight2D = $PointLight2D

var is_open: bool = false

func _ready() -> void:
	_sprite.animation = "light_up"
	_sprite.frame = 0
	_light.enabled = false

func open() -> void:
	if is_open:
		return
	is_open = true
	_light.enabled = true
	_sprite.play("light_up")

func close() -> void:
	if not is_open:
		return
	is_open = false
	_light.enabled = false
	_sprite.play_backwards("light_up")

func set_open(value: bool) -> void:
	if value:
		open()
	else:
		close()


func _on_lever_toggled(is_on: bool) -> void:
	pass # Replace with function body.


func _on_lever_2_toggled(is_on: bool) -> void:
	pass # Replace with function body.
