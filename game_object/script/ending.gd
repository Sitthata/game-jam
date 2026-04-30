extends CanvasLayer

@onready var video: VideoStreamPlayer = $ColorRect/VideoStreamPlayer

func _ready() -> void:
	video.play()

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://game_object/scene/main_menu.tscn")
