extends StaticBody2D

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _occluder: LightOccluder2D = $LightOccluder2D

var is_open: bool = true

func _ready() -> void:
	_collision.set_deferred("disabled", true)
	_occluder.visible = false
	_sprite.animation = "open"
	_sprite.frame = _sprite.sprite_frames.get_frame_count("open") - 1

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
