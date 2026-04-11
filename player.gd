extends CharacterBody2D

@export var speed = 200
@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0:
		_animated_sprite.play("walk")
		_animated_sprite.flip_h = velocity.x < 0
	else:
		_animated_sprite.play("idle")
