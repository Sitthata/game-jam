extends Area2D

signal pressed
signal released

var _bodies_on_plate: int = 0

enum State { OFF, PARTIAL, FULL }  # maps to frame 0, 1, 2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	_bodies_on_plate += 1
	_update_state()
	print("Active: ", _bodies_on_plate)

func _on_body_exited(body: Node2D) -> void:
	_bodies_on_plate = max(0, _bodies_on_plate - 1)
	_update_state()
	print("Active: ", _bodies_on_plate)

func _update_state() -> void:
	if _bodies_on_plate == 0:
		$Sprite2D.frame = State.OFF
		released.emit()
	elif _bodies_on_plate >= 1:
		$Sprite2D.frame = State.FULL
		pressed.emit()
