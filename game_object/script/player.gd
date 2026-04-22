extends CharacterBody2D

@export var speed = 200
@export var push_speed = 50
@export var camera_look_strength: float = 0.3
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _effect_sprite = $EffectSprite
@onready var _camera = $Camera2D

var _last_dir: String = "front"

func _ready() -> void:
	add_to_group("player")

func play_fall_animation(callback: Callable) -> void:
	_animated_sprite.play("fall")
	_animated_sprite.animation_finished.connect(func():
		callback.call()
	, CONNECT_ONE_SHOT)

func play_swap_effect() -> void:
	_animated_sprite.visible = false
	_effect_sprite.visible = true
	_effect_sprite.play("jump")
	_effect_sprite.animation_finished.connect(func():
		_effect_sprite.visible = false
		_animated_sprite.visible = true
	, CONNECT_ONE_SHOT)

func _process(_delta: float) -> void:
	var visible_half = get_viewport_rect().size / 2.0 / _camera.zoom
	var mouse_offset = get_global_mouse_position() - global_position
	_camera.offset = mouse_offset / visible_half * camera_look_strength

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
				_last_dir = "front"
			else:
				_animated_sprite.play("walk_back")
				_last_dir = "back"
		else:
			_animated_sprite.play("walk_side")
			_animated_sprite.flip_h = velocity.x > 0
			_last_dir = "side"
	else:
		#_animated_sprite.play("idle_" + _last_dir)
		_animated_sprite.play("idle")
