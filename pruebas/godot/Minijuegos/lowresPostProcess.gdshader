shader_type canvas_item;
uniform int amount = 450;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment()
{
	vec2 grid_uv = round(UV * float(amount)) / float(amount);
	
 COLOR = textureLod(screen_texture, grid_uv, 0.0);

}


void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
