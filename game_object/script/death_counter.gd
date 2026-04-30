extends Label

var _count: int = 0

func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	text = "0"

func _on_player_died() -> void:
	_count += 1
	text = str(_count)
