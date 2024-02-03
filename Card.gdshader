shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}
uniform vec2 rect_size;

void fragment() {
    float radius = 0.5 * min(rect_size.x, rect_size.y); // Use the minimum of width and height for a perfect circle
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = FRAGCOORD.xy / rect_size;
    float dist = distance(uv, center);
    if (dist > radius) {
        discard;
    }
    COLOR = vec4(1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
