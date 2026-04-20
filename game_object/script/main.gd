extends Node

@onready var present: Node2D = $Present
@onready var past: Node2D = $Past
@onready var player: CharacterBody2D = $Player
@onready var spawn_point: Marker2D = $SpawnPoint

var in_present: bool = true

func _ready() -> void:
	_apply_timeline_state()
	player.global_position = spawn_point.global_position
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeline_swap"):
		var destination = past if in_present else present
		if _has_collision_at_player(destination):
			print("can't jump")
			return
		in_present = !in_present
		_apply_timeline_state()


func _apply_timeline_state() -> void:
	player.play_swap_effect()
	_set_timeline_active(present, in_present)
	_set_timeline_active(past, !in_present)
	# Layer 1=present, 2=past, 3(bit)=player, 4(bit)=global
	player.collision_mask = (1 if in_present else 2) | 4 | 8
	
	print(player.collision_mask)


func _set_timeline_active(timeline: Node2D, active: bool) -> void:
	timeline.visible = active
	for child in timeline.get_children():
		if child is TileMapLayer:
			child.collision_enabled = active

func _has_collision_at_player(timeline: Node2D) -> bool:
	for layer in timeline.get_children():
		if layer is TileMapLayer:
			var map_pos = layer.local_to_map(layer.to_local(player.global_position))
			var tile_data = layer.get_cell_tile_data(map_pos)
			if tile_data != null and tile_data.get_collision_polygons_count(0) > 0:
				return true
	return false
