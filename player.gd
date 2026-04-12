extends CharacterBody2D

@export var speed = 200
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _effect_sprite = $EffectSprite

func _ready() -> void:
	_effect_sprite.stop()

func play_swap_effect() -> void:
	_animated_sprite.visible = false
	_effect_sprite.visible = true
	_effect_sprite.play("jump")
	_effect_sprite.animation_finished.connect(func():
		_effect_sprite.visible = false
		_animated_sprite.visible = true
	, CONNECT_ONE_SHOT)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0:
		if abs(velocity.y) >= abs(velocity.x):
			if velocity.y > 0:
				_animated_sprite.play("walk_front")
			else:
				_animated_sprite.play("walk_back")
		else:
			_animated_sprite.play("walk_side")
			_animated_sprite.flip_h = velocity.x > 0
	else:
		_animated_sprite.play("idle")
