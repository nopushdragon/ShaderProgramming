#version 330

layout(location=0) out vec4 FragColor;

uniform vec4 u_Color;
uniform float u_Time;
uniform vec4 u_Points[500];
uniform sampler2D u_RGBTex;

in vec2 v_Tex;

const float c_PI = 3.141592;


void BW()
{

	if(v_Tex.x <0.5){
		FragColor = vec4(0);
	}
	else{
		FragColor = vec4(1);
	}

	//FragColor = vec4(sin(v_Tex.x*3.14), cos(v_Tex.y*3.14),cos((v_Tex.x * v_Tex.y) * 3.14),1);
}


void Line()
{
	float trans = c_PI / 2;
	float periodX = (v_Tex.x * 2 * c_PI - trans) * 5;
	float periodY = (v_Tex.y * 2 * c_PI - trans) * 5;
	float valueX = pow(abs(sin(periodX)),16);
	float valueY = pow(abs(sin(periodY)),16);
	


	FragColor = vec4(max(valueX,valueY));
}

void Circle()
{
	vec2 center = vec2(0.5,0.5);
	vec2 curpos = v_Tex;

	float d = distance(curpos,center);
	float width = 0.01;
	float radius = 0.5;

	if( d > radius - width&& d < radius){
		FragColor = vec4(1);
	}
	else{
		FragColor = vec4(0);
	}
}

void Circles()
{
	vec2 center = vec2(0.5,0.5);
	vec2 curpos = v_Tex;
	float count = 5;

	float d = distance(curpos,center);

	float grey = pow(abs(sin(d * 4 * c_PI * count - u_Time)),32);
	
	FragColor = vec4(grey);

}

void RainDrop()
{	
	float accum = 0;

	for(int i = 0 ;i  < 500 ; i ++){
	float sTime = u_Points[i].z;
	float lTime = u_Points[i].w;
	float newTime = u_Time - sTime; 
	if(newTime > 0){
		float t = fract(newTime/lTime);
		float oneMinus = 1 - t; // 1 ~ 0
		t = t*lTime;
		vec2 center = u_Points[i].xy;
		vec2 curpos = v_Tex;
		float count = 5;
		float range = t/5;

		float d = distance(curpos,center);
		float fade = (1/range)*clamp(range - d, 0, 1);

		float grey = pow(abs(sin(d * 4 * c_PI * count - t * 10)),32);
		
		accum += grey * fade * oneMinus;
		}
	}
	FragColor = vec4(accum);


}

void TextureSampling()
{
	FragColor = texture(u_RGBTex,v_Tex);
}

void TextureQ1()
{
	float tx = v_Tex.x;
	float ty = 1 - abs((v_Tex.y * 2) - 1);

	vec2 tex = vec2(tx,ty);
	FragColor = texture(u_RGBTex,tex);
}

void TextureQ2()
{
	float tx = fract(v_Tex.x * 3);
	float ty = v_Tex.y / 3;

	float offsetX = 0;
	float offsetY = (2 - floor(v_Tex.x * 3)) / 3;

	vec2 tex = vec2(offsetX + tx, offsetY + ty);
	FragColor = texture(u_RGBTex,tex);
}

void TextureQ3()
{
	float tx = fract(v_Tex.x * 3);
	float ty = v_Tex.y / 3;

	float offsetX = 0;
	float offsetY = floor(v_Tex.x * 3) / 3;

	vec2 tex = vec2(offsetX + tx, offsetY + ty);
	FragColor = texture(u_RGBTex,tex);
}

void main()
{
	TextureQ3();
}
