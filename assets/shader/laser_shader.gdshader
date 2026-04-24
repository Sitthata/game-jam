shader_type canvas_item;

uniform sampler2D laser_texture : repeat_enable, filter_linear;
uniform float scroll_speed : hint_range(0.0, 5.0) = 1.5;
uniform float tile_count : hint_range(1.0, 20.0) = 4.0;

void fragment() {
	vec2 uv = vec2(UV.x * tile_count - TIME * scroll_speed, UV.y);
	COLOR = texture(laser_texture, uv) * COLOR;
}
