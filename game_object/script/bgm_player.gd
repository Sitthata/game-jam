extends AudioStreamPlayer

func _ready() -> void:
	volume_db = -15.0
	stream = preload("res://assets/audio/game_bgm.wav")
	play()
