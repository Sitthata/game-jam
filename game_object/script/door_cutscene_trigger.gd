extends Area2D

@export var door_left: Node2D
@export var door_right: Node2D
@export var hold_duration: float = 0.8

var _triggered := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _triggered or not body.is_in_group("player"):
		return
	_triggered = true

	var player = body
	var camera = player.get_node("Camera2D")
	player._is_panning = true

	var tween = create_tween()

	tween.tween_property(camera, "offset",
		door_left.global_position - player.global_position, 0.6
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(door_left.open)
	tween.tween_interval(hold_duration)

	tween.tween_property(camera, "offset",
		door_right.global_position - player.global_position, 0.6
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(door_right.open)
	tween.tween_interval(hold_duration)

	tween.tween_property(camera, "offset", Vector2.ZERO, 0.6
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(func():
		var displays := get_tree().get_nodes_in_group("hint_display")
		if displays.size() > 0:
			displays[0].show_hint("I should explore", 3.0)
		player._is_panning = false
	)
