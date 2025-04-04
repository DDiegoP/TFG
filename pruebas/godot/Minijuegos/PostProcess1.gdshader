shader_type canvas_item;

uniform vec2 size = vec2(8.0, 4.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
		//float sizew = (1.0/1920.0);
		//float sizeh = (1.0/1080.0);
		//vec2 factor = vec2(sizew*2.0,sizeh*2.0);
		//SCREEN_PIXEL_SIZE
		vec2 factor = vec2(3.5,3.5);
        vec2 norm_size = size * SCREEN_PIXEL_SIZE/factor; //factor;
		//vec2 norm_size = size * factor;
        bool less_than_half = mod(SCREEN_UV.y / 2.0, norm_size.y) / norm_size.y < 0.5;
        vec2 uv = SCREEN_UV + vec2(norm_size.x * 0.5 * float(less_than_half), 0.0);
        vec2 center_uv = floor(uv / norm_size) * norm_size;
        vec2 norm_uv = mod(uv, norm_size) / norm_size;
        center_uv += mix(vec2(0.0, 0.0),
                         mix(mix(vec2(norm_size.x, -norm_size.y),
                                 vec2(0.0, -norm_size.y),
                                 float(norm_uv.x < 0.5)),
                             mix(vec2(0.0, -norm_size.y),
                                 vec2(-norm_size.x, -norm_size.y),
                                 float(norm_uv.x < 0.5)),
                             float(less_than_half)),
                         float(norm_uv.y < 0.3333333) * float(norm_uv.y / 0.3333333 < (abs(norm_uv.x - 0.5) * 2.0)));

        COLOR = textureLod(screen_texture, center_uv, 0.0);
}