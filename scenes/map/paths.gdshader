shader_type canvas_item;

uniform float speed = 0.5;
uniform float threshold = 0.2;
uniform float world_scale = 4.0;

vec3 palette(float t)
{
    return 0.5 + 0.5 * cos(6.28318 * (t + vec3(0.0, 0.33, 0.67)));
}

void fragment()
{
    vec4 base = texture(TEXTURE, UV);

    float blue_mask = base.b - max(base.r, base.g);
    float mask = smoothstep(threshold, threshold + 0.2, blue_mask);

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