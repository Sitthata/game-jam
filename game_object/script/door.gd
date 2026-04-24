extends StaticBody2D

@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _occluder: LightOccluder2D = $LightOccluder2D

func _ready() -> void:
	_collision.set_deferred("disabled", true)
	_occluder.visible = false
	_sprite.animation = "open"
	_sprite.frame = 0

func open() -> void:
	_collision.set_deferred("disabled", true)
	_occluder.visible = false
	_sprite.play("open")

func close() -> void:
	_collision.set_deferred("disabled", false)
	_occluder.visible = true
	_sprite.play_backwards("open")  # rewinds the open animation as a close

func set_open(open: bool) -> void:
	if open:
		open()
	else:
		close()
