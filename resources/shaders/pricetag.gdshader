shader_type canvas_item;

uniform vec4 tint_color = vec4(1.0, 1.0, 1.0, 1.0); // optional: color
uniform float brightness = 1.0; // range 0.0 - 2.0
uniform float saturation = 1.0; // range 0.0 - 2.0

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV) * tint_color;

    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 saturated_color = mix(vec3(gray), tex_color.rgb, saturation);
    vec3 final_color = saturated_color * brightness;

    COLOR = vec4(final_color, tex_color.a);
}
