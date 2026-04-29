extends PanelContainer

@onready var _label: Label = $Label

var _tween: Tween = null

func _ready() -> void:
	add_to_group("hint_display")
	modulate.a = 0.0
	_label.text = ""

func show_hint(text: String, duration: float) -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
		_tween = null

	_label.text = text
	modulate.a = 0.0

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	_tween.tween_interval(duration)
	_tween.tween_property(self, "modulate:a", 0.0, 0.3)
