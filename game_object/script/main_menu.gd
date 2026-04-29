extends Node2D

@onready var start_button: Button = $Control/StartButton
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

func _ready() -> void:
	player_sprite.play("idle_front")


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://game_object/scene/tile_map.tscn")
