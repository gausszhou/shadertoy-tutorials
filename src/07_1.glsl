#define TMIN 0.1
#define TMAX 20.0
#define RAYMARCH_TIME 128
#define PRECISION .001

vec2 fixUV(in vec2 c) {
  return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

float sdfSphere(in vec3 p){
  return length(p) - .5;
}

float rayMarch(in vec3 ro, in vec3 rd){
  float t = TMIN;
  for(int i = 0; i < RAYMARCH_TIME && t < TMAX; i++){
    vec3 p = ro + t * rd; //步进
    float d = sdfSphere(p);
    if(d < PRECISION){
      break;
    }
    t += d;
  }
  return t;
}

vec3 render( in vec2 uv){
  vec3 color = vec3(0.);
  vec3 ro = vec3(0., 0., -2.); // 相机位置
  vec3 rd = normalize(vec3(uv, 0.) - ro); // 对每个像素的方向向量
  float t = rayMarch(ro,rd); // 对每个像素进行步进
  if(t < TMAX){
    color = vec3(1.);
  }
  return color;
}

void mainImage (out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = fixUV(fragCoord);    
    vec3 color = render(uv);
    fragColor = vec4(color, 1.); // rgba
}
