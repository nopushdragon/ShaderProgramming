#version 330

layout(location=0) out vec4 FragColor;

uniform vec4 u_Color;
uniform float u_Time;

in vec2 v_Tex;

float c_PI = 3.141592;

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
	
	FragColor = vec4(0.7,grey - mod(u_Time,1.0),0.2,1);

}

void main()
{
	Circles();
}
