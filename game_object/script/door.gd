extends StaticBody2D

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_collision.set_deferred("disabled", true)
	_sprite.frame = _sprite.sprite_frames.get_frame_count("open") - 1

func open() -> void:
	_collision.set_deferred("disabled", true)
	_sprite.play("open")

func close() -> void:
	_collision.set_deferred("disabled", false)
	_sprite.play_backwards("open")  # rewinds the open animation as a close
