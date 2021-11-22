shader_type canvas_item;

uniform vec2 emotionPointer = vec2(0.0, 0.0);
uniform float proportion = 0.5;

uniform sampler2D texEmotionalColors : hint_black;

void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	vec4 emotionColor = texture(texEmotionalColors, emotionPointer);
	float darkness = (texColor.r + texColor.g + texColor.b) / 3.0;
	float filteredProportion = darkness * proportion;
	COLOR = emotionColor * filteredProportion;
	COLOR.a = texColor.a;
}