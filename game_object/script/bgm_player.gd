extends AudioStreamPlayer

func _ready() -> void:
	volume_db = -15.0
	var s := preload("res://assets/audio/game_bgm.wav")
	stream = s
	play()
