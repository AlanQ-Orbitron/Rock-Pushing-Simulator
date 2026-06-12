shader_type canvas_item;

uniform vec2 resolution = vec2(1152.0, 648.0);
uniform sampler2D noise_texture: filter_nearest, repeat_enable;
uniform float density: hint_range(1.0, 100.0, 0.1);

void fragment() {
	vec2 uv = UV;
	uv.x *= resolution.x / resolution.y;
	float stars = 0.0;
	stars += pow(texture(noise_texture, uv).r, density);
	COLOR = vec4(vec3(1), stars);
}