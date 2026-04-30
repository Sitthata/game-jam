extends Area2D

@export var hint_text: String = ""
@export var display_duration: float = 10.0

var _triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _triggered:
		return
	if not body.is_in_group("player"):
		return
	_triggered = true
	var displays := get_tree().get_nodes_in_group("hint_display")
	if displays.is_empty():
		return
	displays[0].show_hint(hint_text, display_duration)
