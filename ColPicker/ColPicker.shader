shader_type canvas_item;
// types [0 = checker , 1 = Color , 2 = Hue , 3 = Alpha]
uniform int type = 0;
// 0
uniform vec2 size = vec2(1, 1);
// 1
uniform float hue;
// 3
uniform vec4 color : hint_color;


vec3 _hue(float x) {
	float r; float g; float b;
	float one = 1./6.; float two = 2./6.;float three = 0.5; float four = 4./6.; float five = 5./6.;
	if (x >= 0. && x < one) {
		r = 1.; g = x/one;
	}else if (x >= one && x < two){
		r = 1. - (x - one)/one; g = 1.;
	}else if (x >= two && x < three){
		g = 1.; b = (x - two)/one;
	}else if (x >= three && x < four){
		g = 1. - (x - three)/one; b = 1.;
	}else if (x >= four && x < five){
		r = (x - four)/one; b = 1.;
	}else{
		r = 1.; b = 1. - (x - five)/one;
	}
	return vec3(r, g, b);
}

// Credits to viruseg on github
vec3 hue_shift(vec3 _col, float _hue_adjust) {
    const vec3 k = vec3(0.57735);
    float cos_angle = cos(_hue_adjust);
    return _col * cos_angle + cross(k, _col) * sin(_hue_adjust) + k * dot(k, _col) * (1.0 - cos_angle);
}

void fragment() {
	if (type == 0) {
		vec2 uv = fract(UV * size / 4.);
		uv -= .5;
		vec3 checker = clamp(vec3(step(uv.x * uv.y, 0.)), vec3(.4), vec3(.6));
		COLOR.rgb = checker;
	} else if (type == 1) {
		vec3 gray = 1. - vec3(1.) * UV.y;
		vec3 col = 0.925 - vec3(0., 1., 1.) * UV.x;
		COLOR.rgb = gray * hue_shift(col, hue * 6.283);
	} else if (type == 2) {
		COLOR.rgb = _hue(UV.x);
	} else {
		COLOR = vec4(vec3(color.rgb), UV.x);
	}
}



