extends CharacterBody2D

@export var speed = 200
@export var push_speed = 50
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _effect_sprite = $EffectSprite

func _ready() -> void:
	add_to_group("player")

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
	
	# Logic to push object
	if direction.length() > 0:
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			var collider = col.get_collider()
			if collider and collider.has_method("push"):
				collider.push(col.get_normal() * -1, push_speed)


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
