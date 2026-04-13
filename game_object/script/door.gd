extends StaticBody2D

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func open() -> void:
	_sprite.play("open")
	# Disable collision once the open animation finishes
	_sprite.animation_finished.connect(
		func(): _collision.set_deferred("disabled", true),
		CONNECT_ONE_SHOT
	)

func close() -> void:
	_collision.set_deferred("disabled", false)
	_sprite.play_backwards("open")  # rewinds the open animation as a close
