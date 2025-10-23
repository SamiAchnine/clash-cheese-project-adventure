shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 2.0) = 0.3;
uniform float zoom : hint_range(0.5, 10.0) = 2.0;

// Simple hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
	vec2 uv = FRAGCOORD.xy * SCREEN_PIXEL_SIZE * zoom;
    float t = TIME * time_speed;

    // Layered noise for richer detail
    float n = noise(uv + vec2(t * 0.2, t * 0.4));
    float n2 = noise(uv * 2.0 - vec2(t * 0.1, t * 0.3));

    float val = (n + n2 * 0.5);
    vec3 color = vec3(
        0.3 + 0.7 * val,
        0.2 + 0.5 * sin(val * 3.0 + t),
        0.6 + 0.4 * cos(val * 2.0 - t)
    );

    COLOR = vec4(color, 1.0);
}
