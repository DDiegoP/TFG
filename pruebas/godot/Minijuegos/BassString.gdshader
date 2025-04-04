shader_type canvas_item;
uniform float sr = 0.0;
uniform float sg = 0.0;
uniform float sb = 0.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(sr, sg, sb, 1.0)*color;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
