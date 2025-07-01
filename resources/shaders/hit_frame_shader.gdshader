shader_type canvas_item;

uniform vec4 outline_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec3 fill_color: source_color = vec3(1.0, 1.0, 1.0);
uniform float outline_thickness = 1.0;
uniform float intensity: hint_range(0.0, 1.0, 0.1) = 0.0;

const vec2[4] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0)
};

// returns 1.0 if input > 0, else 0.0
float gtz(float input) {
	return max(0, sign(input));
}

// checkt if the outline color has to be applied
// I do not know what is going on here I just coppied this part
float check(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4; i++) {
		// excuse me what?
		result += texture(tex, from + DIRECTIONS[i] * size * outline_thickness).a;
	}
	return gtz(result);
}

// apply the shader for each pixel
void fragment() {
	// calculate the hit frame color. Set the fill color if check is false and the outline color if true
	vec4 hit_frame_color = mix(
		vec4(fill_color, COLOR.a),
		outline_color,
		check(TEXTURE, UV, TEXTURE_PIXEL_SIZE) * (1.0 - gtz(COLOR.a)));

	// apply the hitframe color based on the intensity
	COLOR = mix(COLOR, hit_frame_color, intensity);
}