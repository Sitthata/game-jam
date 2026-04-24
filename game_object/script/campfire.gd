extends Node2D
  
@onready var campfire_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	campfire_sprite.play("flame")
