#version 330

uniform float u_Time;

//in vec3 a_Position;
//in float a_Mass;
//in vec2 a_Vel;
//in float a_RV;
//in float a_RV1;

layout(location = 0) in vec4 a_PosMass; 
layout(location = 1) in vec4 a_VelRV;
in float a_RV2;

vec3 a_Position = a_PosMass.xyz;
float a_Mass = a_PosMass.w;
vec2 a_Vel = a_VelRV.xy;
float a_RV = a_VelRV.z;
float a_RV1 = a_VelRV.w;

const float c_PI = 3.141592; 
const vec2 c_G = vec2(0, -9.8);

out float v_Grey;


void sin1() // ai가 만들었는데 잘 안됐음 ai 똥멍청함;;
{
    float movement = mod(u_Time, 2.0); 

    vec4 newPosition = vec4(a_Position, 1.0);
    newPosition.x += movement;

    if (newPosition.x > 1.0) {
        newPosition.x -= 2.0;
    }

    newPosition.y += sin(u_Time * 5.0) * 0.5;

    gl_Position = newPosition;
}

void Basic()
{
    float t = mod(u_Time*10, 1.0);

	vec4 newPosition;
	newPosition = vec4(a_Position, 1);
	newPosition += vec4(-1 + t*2, 0.5*sin(t*2*3.141592), 0, 0);

	gl_Position = newPosition;
}

void circle()
{
    float t = mod(u_Time*10, 1.0);

    vec4 newPosition;
	newPosition.x = a_Position.x + cos(t*2*3.14)*0.5;
    newPosition.y = a_Position.y + sin(t*2*3.14)*0.5;
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

	gl_Position = newPosition;
}

void sangsang()
{
   float speed = u_Time * 10.0;
    float progress = mod(speed, 1.0);

    // 1. 메인 대각선 경로 (왼쪽 위 -> 오른쪽 아래)
    vec2 startPos = vec2(-0.8, 0.8);
    vec2 endPos = vec2(0.8, -0.8);
    vec2 mainPath = mix(startPos, endPos, progress);

    // 2. 대각선에 수직인 벡터 계산
    // 대각선 방향이 (1, -1)이므로, 수직 방향은 (1, 1)이 됩니다.
    vec2 perpendicularDir = vec2(1.0, 1.0);

    // 3. 수직 방향 지그재그 (빠른 왕복)
    float zigzagSpeed = 50.0;
    float zigzagWidth = 0.3;
    float offset = sin(speed * zigzagSpeed) * zigzagWidth;

    // 4. 최종 위치: 메인 경로 + 수직 왕복 오프셋
    vec4 newPosition;
    newPosition.xy = mainPath + (perpendicularDir * offset);
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

    // 실제 정점의 기본 위치(a_Position)를 더해 도형의 형태 유지
    gl_Position = vec4(newPosition.xy + a_Position.xy, newPosition.z, 1.0);
}

void sangsang2(){
// 전체 진행 주기 조절
    float speed = u_Time * 10.0;
    float progress = mod(speed, 1.0);

    // 1. X축 이동: 왼쪽(-0.8)에서 오른쪽(0.8)으로 일정하게 진행
    float currentX = mix(-0.8, 0.8, progress);

    // 2. Y축 이동: 중력 및 탄성 효과
    // mod를 이용해 튕기는 주기를 만듭니다 (예: 한 번 내려오는 동안 4번 튕김)
    float bounceCount = 3.0;
    float bounceProgress = mod(progress * bounceCount, 1.0);
    
    // 포물선 공식: y = 4 * height * t * (1 - t) 
    // 위 식을 뒤집어서 abs를 활용하면 튕기는 모양이 나옵니다.
    float height = 0.6;
    float bounceY = 4.0 * height * bounceProgress * (1.0 - bounceProgress);
    
    // 전체적인 하강 곡선 + 튕기는 높이 결합
    // 위(0.8)에서 아래(-0.8)로 내려가는 기본 축에 bounceY를 더함
    float baseLineY = mix(0.5, -0.8, progress);
    float currentY = baseLineY + bounceY;

    vec4 newPosition;
    newPosition.x = a_Position.x + currentX;
    newPosition.y = a_Position.y + currentY;
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

    gl_Position = newPosition;
}

float pseudoRandom(float n){
    return fract(sin(n) * 43758.5453123);
}

//void falling()
//{
//    float newTime = u_Time - a_RV1;
//    if(newTime > 0){
//        float t =  mod(newTime, 1.0);
//        float tt = t*t;
//        float vx = a_Vel.x;
//        float vy = a_Vel.y;
//        float initPosX = a_Position.x + cos(a_RV * c_PI) * 0.7;
//        float initPosY = a_Position.y + sin(a_RV * c_PI) * 0.7;
//
//        vec4 newPos;
//        newPos.x = initPosX + vx * t + 0.5 * c_G.x * tt;
//        newPos.y = initPosY + vy * t + 0.5 * c_G.y * tt;
//        newPos.z = 0;
//        newPos.w = 1;
//
//        gl_Position = newPos;
//    }
//    else {
//        gl_Position = vec4(-2.0, -2.0, 0.0, 1.0); // 화면 밖으로 숨김
//    }
//}

void falling()
{
    float newTime = u_Time - a_RV1*3; 
    if(newTime > 0){ 
        float lifeTime = a_RV2 + 0.5;
        //float scale = pseudoRandom(a_RV1);
        float t = mod(newTime, lifeTime)/lifeTime; 
        float tt = t * t; 
        float scale = lifeTime - t;
        
        float initPosX = a_Position.x * scale + cos(a_RV * c_PI) * 0.7; 
        float initPosY = a_Position.y * scale + sin(a_RV * c_PI) * 0.7; 

        vec4 newPos;
        //newPos.x = initPosX + a_Vel.x * t + 0.5 * c_G.x * tt; 
        newPos.x = initPosX; 
        newPos.y = initPosY + a_Vel.y * t + 0.5 * c_G.y * tt; 
        newPos.z = 0;
        newPos.w = 1;
        gl_Position = newPos; 
    }
    else {
        gl_Position = vec4(-2.0, -2.0, 0.0, 1.0);
    }
}

void Thrust()
{
    float newTime = u_Time - a_RV1;
    if(newTime >0){
        float t = mod(newTime, 1.0);
        float ampScale = 0.5 - t*0.5;
        float amp = (a_RV-0.5)*2;
        float period = a_RV2;
        float sizeScale = 2 - t*2;

	    vec4 newPosition;
	    newPosition.x = a_Position.x * sizeScale - 1 + 2 * t;
        newPosition.y = a_Position.y * sizeScale + amp * ampScale * sin(t*2*period*c_PI);
        newPosition.z = a_Position.z;
        newPosition.w = 1.0;
        gl_Position = newPosition;
        v_Grey = 1-t;
    }
    else{
        gl_Position = vec4(10000);
    }
}

void main()
{
	Thrust();
}