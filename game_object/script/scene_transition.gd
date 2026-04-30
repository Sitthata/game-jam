extends CanvasLayer

var overlay: ColorRect

func _ready() -> void:
	layer = 100
	overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.modulate.a = 0.0
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay)

func change_scene(path: String) -> void:
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	await _fade(1.0)
	get_tree().change_scene_to_file(path)
	await _fade(0.0)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _fade(target_alpha: float) -> void:
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", target_alpha, 0.6)
	await tween.finished
