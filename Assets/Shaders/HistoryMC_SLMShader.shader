shader_type canvas_item;

uniform vec2 screenSize;
uniform sampler2D texHSL : hint_black;

void fragment() {
	vec2 pixelSize = 1.0 / screenSize;
	float countM = 0.0;
	float countC = 0.0;
	float amountS = 0.0;
	float amountL = 0.0;
	
	for(float x = 0.0; x < screenSize.x; x++) {
		for(float y = 0.0; y < screenSize.y; y++) {
			vec4 HSL = texture(texHSL, vec2(x * pixelSize.x, y * pixelSize.y));
			float hue = HSL.r * 360.0;
			if(hue <= 330.0 && hue > 270.0) {
				countM++;
			} else if(hue <= 210.0 && hue > 150.0) {
				countC++;
			}
			amountS += HSL.g;
			amountL += HSL.b;
		}
	}
	//vec4 result = vec4(countM, countC, amountS, amountL);
	vec4 result = vec4(countM, amountS, amountL, 1.0);
	result.xyz /= screenSize.x * screenSize.y;
	COLOR = result;
}