shader_type canvas_item;

uniform float scale = 0.5;
uniform float speed = 0.01;
uniform vec2 direction = vec2(1, 0);

void fragment() {
	vec2 offset = normalize(direction) * speed * TIME * TEXTURE_PIXEL_SIZE;
	vec2 size = vec2(textureSize(TEXTURE, 0));
	vec2 uv = (UV / size.yx) * length(size);
	COLOR = texture(TEXTURE, (uv * scale) + offset);
	
}
