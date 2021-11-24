shader_type canvas_item;

float fMod(float value, float m) {
	float temp = value / m;
	return (temp - floor(temp)) * m; 
}

vec3 RGB2HSL(vec3 RGB) {
	vec3 HSL = vec3(0, 0, 0);
	
	float cMax = max(max(RGB.r, RGB.g), RGB.b);
	float cMin = min(min(RGB.r, RGB.g), RGB.b);
	float delta = cMax - cMin;
	
	HSL.b = (cMax +cMin) / 2.0;
	
	if(delta == 0.0) {
		HSL.r = 0.0;
		HSL.g = 0.0;
	} else {
		HSL.g = delta / (1.0 - abs(2.0 * HSL.b - 1.0));
		if(cMax == RGB.r) {
			HSL.r = 60.0 * mod((RGB.g - RGB.b) / delta, 6.0);
		} else if(cMax == RGB.g) {
			HSL.r = 60.0 * ((RGB.b - RGB.r) / delta + 2.0);
		} else if(cMax == RGB.b) {
			HSL.r = 60.0 * ((RGB.r - RGB.g) / delta + 4.0);
		}
		HSL.r = fMod(HSL.r, 360.0);
		HSL.r /= 360.0;
	}
	
	return HSL;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(RGB2HSL(color.rgb), color.a);
}