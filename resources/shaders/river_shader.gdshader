shader_type canvas_item;

uniform float base_speed = 0.01;
uniform float width = 1.0;
uniform float distance_from_viewer = 1.0;

void fragment() {
	// calculate perceived speed based on distance to the viewer using the formula for angular speed (ω=v/r)
	float perceived_flow_speed = base_speed / (width * (1.0 - UV.y) + distance_from_viewer);
	
	// calculate sampler offset with speed and time
	float calculated_offset = -UV.x + TIME * perceived_flow_speed;
	float sample_uv_x = mod(calculated_offset, 1.0);
	
	// apply color from calcualted offset
	COLOR = texture(TEXTURE, vec2(sample_uv_x, UV.y));
}
