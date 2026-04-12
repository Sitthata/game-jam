extends Node

@onready var present: Node2D = $Present
@onready var past: Node2D = $Past

var in_present: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_timeline_state()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeline_swap"):
		in_present = !in_present
		_apply_timeline_state()


func _apply_timeline_state() -> void:
	_set_timeline_active(present, in_present)
	_set_timeline_active(past, !in_present)
	

func _set_timeline_active(timeline: Node2D, active: bool) -> void:
	timeline.visible = active
	for child in timeline.get_children():
		if child is TileMapLayer:
			child.collision_enabled = active
