shader_type canvas_item;

uniform vec2 screenSize;
uniform sampler2D texHSL : hint_black;

void fragment() {
	vec2 pixelSize = vec2(1.0, 1.0) / screenSize;
	float countR = 0.0;
	float countG = 0.0;
	float countB = 0.0;
	float countY = 0.0;
	
	for(float x = 0.0; x < screenSize.x; x++) {
		for(float y = 0.0; y < screenSize.y; y++) {
			vec4 HSL = texture(texHSL, vec2(x * pixelSize.x, y * pixelSize.y));
			float hue = HSL.r * 360.0;
			if(hue <= 30.0 && hue > 330.0) {
				countR++;
			} else if(hue <= 150.0 && hue > 90.0) {
				countG++;
			} else if(hue <= 270.0 && hue > 210.0) {
				countB++;
			} else if(hue <= 90.0 && hue > 30.0) {
				countY++;
			}
		}
	}
	//vec4 result = vec4(countR, countG, countB, countY);
	vec4 result = vec4(countR, countG, countB, 1.0);
	result.xyz /= screenSize.x * screenSize.y;
	COLOR = result;
}