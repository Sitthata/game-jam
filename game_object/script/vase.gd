# vase.gd
extends CharacterBody2D

signal landed_on_plate  # emitted when vase enters a plate Area2D
signal lifted_from_plate

@onready var _effect_sprite: AnimatedSprite2D = $EffectSprite

var _initial_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_initial_position = global_position

func push(direction: Vector2, push_speed: float) -> void:
	velocity = direction * push_speed
	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider and collider.has_method("push"):
			collider.push(col.get_normal() * -1, push_speed)
	velocity = Vector2.ZERO

# VERSION A (active): effect plays at current vase position, then teleport
#func reset() -> void:
	#_effect_sprite.visible = true
	#_effect_sprite.play("jump")
	#_effect_sprite.animation_finished.connect(func():
		#_effect_sprite.visible = false
		#global_position = _initial_position
		#velocity = Vector2.ZERO
	#, CONNECT_ONE_SHOT)

 #VERSION B (commented): teleport immediately, effect plays at destination
func reset() -> void:
	global_position = _initial_position
	velocity = Vector2.ZERO
	_effect_sprite.visible = true
	_effect_sprite.play("jump")
	_effect_sprite.animation_finished.connect(func():
		_effect_sprite.visible = false
	, CONNECT_ONE_SHOT)
