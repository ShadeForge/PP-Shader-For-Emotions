shader_type canvas_item;

uniform sampler2D texHistory;
uniform sampler2D texHSL;
uniform float targetArousal;
uniform float targetValence;
uniform float targetGreenValue = 0.05;

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

vec3 HSL2RGB(vec3 HSL) {
	vec3 RGB = vec3(0, 0, 0);
	HSL.r *= 360.0;
	float c = (1.0 - abs(2.0 * HSL.b - 1.0)) * HSL.g;
	float x = c * (1.0 - abs(fMod(HSL.r / 60.0, 2.0) - 1.0));
	float m = HSL.b - c / 2.0;
	
	if(0.0 <= HSL.r && HSL.r < 60.0) {
		RGB = vec3(c, x, 0);
	} else if(60.0 <= HSL.r && HSL.r < 120.0) {
		RGB = vec3(x, c, 0);
	} else if(120.0 <= HSL.r && HSL.r < 180.0) {
		RGB = vec3(0, c, x);
	} else if(180.0 <= HSL.r && HSL.r < 240.0) {
		RGB = vec3(0, x, c);
	} else if(240.0 <= HSL.r && HSL.r < 300.0) {
		RGB = vec3(x, 0, c);
	} else if(300.0 <= HSL.r && HSL.r < 360.0) {
		RGB = vec3(c, 0, x);
	}
	
	RGB.xyz += m;
	
	return RGB;
}

vec2 calculateAV(float hueB, float hueG, float meanSaturation) {
	return vec2(4.762 + 2.914 * hueB - 1.707 * meanSaturation,
				3.109 + 8.476 * hueG + 3.548 * meanSaturation);
}

vec3 calculateGBS(float greenValue) {
	vec3 result = vec3(greenValue, 0.0, 0.0);
	
	result.b = 0.28184 * targetValence - 2.38895 * greenValue - 0.87626; // Saturation
	result.g = 0.34317 * targetArousal + 0.58579 * result.b - 1.63417; // BlueValue
	
	return result;
}

void fragment() {
	vec4 color = texture(texHSL, UV);
	vec4 hueRGBY = texture(texHistory, vec2(1.0/3.0, 0));
	vec4 hueMC_meanSL = texture(texHistory, vec2(2.0/3.0, 0));
	
	vec3 targetGBS = calculateGBS(targetGreenValue);
	
	float tempMaxPropotion = targetGBS.g + targetGreenValue;
	float greenProportion = targetGreenValue / tempMaxPropotion;
	float blueProportion = targetGBS.b / tempMaxPropotion;
	
	float targetHue = (greenProportion * 120.0 + blueProportion * 240.0) / 360.0;
	
	color.r = (color.r + targetHue) / 2.0;
	color.g = (color.g + targetGBS.r) / 2.0;
	
	color.rgb = HSL2RGB(color.rgb);
	
	COLOR = vec4(color.rgb, 1.0);
}