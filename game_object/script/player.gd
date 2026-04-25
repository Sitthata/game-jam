extends CharacterBody2D

@export var speed = 200
@export var push_speed = 50
@export var camera_look_strength: float = 0.3
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _effect_sprite = $EffectSprite
@onready var _camera = $Camera2D

var _last_dir: String = "front"
var _is_playing_fall: bool = false
var _is_playing_swap: bool = false
var _is_playing_death: bool = false

func _ready() -> void:
	add_to_group("player")

func play_fall_animation(callback: Callable) -> void:
	_is_playing_fall = true
	if _is_playing_swap:
		_effect_sprite.animation_finished.connect(func():
			_do_play_fall(callback)
		, CONNECT_ONE_SHOT)
	else:
		_do_play_fall(callback)

func _do_play_fall(callback: Callable) -> void:
	_animated_sprite.play("fall")
	_animated_sprite.animation_finished.connect(func():
		_is_playing_fall = false
		callback.call()
	, CONNECT_ONE_SHOT)

func do_play_death(callback: Callable) -> void:
	_is_playing_death = true
	_animated_sprite.visible = false
	_effect_sprite.visible = true
	_effect_sprite.play("death")
	_effect_sprite.animation_finished.connect(func():
		_is_playing_death = false
		_effect_sprite.visible = false
		_effect_sprite.modulate = Color.WHITE
		_animated_sprite.visible = true
		callback.call()
	, CONNECT_ONE_SHOT)

func play_swap_effect() -> void:
	_is_playing_swap = true
	_animated_sprite.visible = false
	_effect_sprite.visible = true
	_effect_sprite.play("jump")
	_effect_sprite.animation_finished.connect(func():
		_is_playing_swap = false
		_effect_sprite.visible = false
		_animated_sprite.visible = true
	, CONNECT_ONE_SHOT)

func _process(_delta: float) -> void:
	var visible_half = get_viewport_rect().size / 2.0 / _camera.zoom
	var mouse_offset = get_global_mouse_position() - global_position
	_camera.offset = mouse_offset / visible_half * camera_look_strength

func _physics_process(delta: float) -> void:
	if _is_playing_death or _is_playing_fall:
		velocity = Vector2.ZERO
		return
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

	# Use direction (raw input) not velocity (post-collision) so pushing a vase
	# still triggers walk animation even when move_and_slide zeros velocity.
	if direction.length() > 0:
		if abs(direction.y) >= abs(direction.x):
			if direction.y > 0:
				_animated_sprite.play("walk_front")
				_last_dir = "front"
			else:
				_animated_sprite.play("walk_back")
				_last_dir = "back"
		else:
			_animated_sprite.play("walk_side")
			_animated_sprite.flip_h = direction.x > 0
			_last_dir = "side"
	else:
		_animated_sprite.play("idle_" + _last_dir)
