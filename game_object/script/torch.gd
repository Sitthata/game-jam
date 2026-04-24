@tool
extends Node2D

const BASE_ENERGY := 0.8
const FLICKER_STRENGTH := 0.25
const FLICKER_SPEED := 1.3

@export var flip_h: bool = false:
	set(value):
		flip_h = value
		if Engine.is_editor_hint() and is_node_ready():
			$AnimatedSprite2D.flip_h = value

@export var light_offset: Vector2 = Vector2(0, 0):
	set(value):
		light_offset = value
		if is_node_ready():
			$PointLight2D.position = value

@export var light_scale: float = 0.15:
	set(value):
		light_scale = value
		if is_node_ready():
			$PointLight2D.texture_scale = value

@export var light_energy: float = BASE_ENERGY:
	set(value):
		light_energy = value
		if is_node_ready():
			$PointLight2D.energy = value
			
@export var disable_flicker: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	sprite.flip_h = flip_h
	light.position = light_offset
	light.texture_scale = light_scale
	light.energy = light_energy
	if not Engine.is_editor_hint():
		sprite.play("burn")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var t := Time.get_ticks_msec() / 1000.0
	if not disable_flicker:
		light.energy = light_energy + sin(t * FLICKER_SPEED) * FLICKER_STRENGTH * 0.5 \
			+ sin(t * FLICKER_SPEED * 2.3 + 1.1) * FLICKER_STRENGTH * 0.5
