shader_type canvas_item;

uniform float speed = 0.5;
uniform vec4 target_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float color_tolerance = 0.2;
uniform float world_scale = 4.0;

vec3 palette(float t)
{
    return 0.5 + 0.5 * cos(6.28318 * (t + vec3(0.0, 0.33, 0.67)));
}

void fragment()
{
    vec4 base = texture(TEXTURE, UV);

	float distance_from_color = distance(base.rgb, target_color.rgb);
	float mask = 1.0 - step(color_tolerance, distance_from_color);

    vec2 world = SCREEN_UV * world_scale;

    float liquid_rainbow =
        world.x +
        world.y +
        sin(world.x * 2.0 + TIME * speed) +
        cos(world.y * 2.0 - TIME * speed);

    vec3 liquid = palette(liquid_rainbow);

    vec3 color = mix(base.rgb, liquid, mask);

    COLOR = vec4(color, base.a);
}