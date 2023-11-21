#define PI 3.14159265
#define AA 4

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.4);
  vec2 grid = floor(mod(uv, 2.));
  if(grid.x == grid.y) color = vec3(.6);
  color = mix(color, vec3(0.),smoothstep(1.1 * fwidth(uv.x), fwidth(uv.x),abs(uv.x)));
  color = mix(color, vec3(0.),smoothstep(1.1 * fwidth(uv.y), fwidth(uv.y),abs(uv.y)));
  return color;
}

float segment(in vec2 p, in vec2 a, in vec2 b, in float w){
  float f = 0.;
  vec2 ba = b - a;
  vec2 pa = p - a;
  float proj = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
  float d = length(proj * ba - pa);
  if(d <= w){
    f = 1.;
  } 
  return f;
}

float func(in float x){
  float T = 1. + 1. * iTime ;
  return sin( 2. * PI / T * x);
}

float plotFunc(in vec2 uv){
  float f = func(uv.x);
  float w = .01;
  return smoothstep(f - w, f + w, uv.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  float count = 0.;
  for(int m = 0; m < AA; m++){
    for(int n = 0 ; n < AA; n++){
      vec2 offset = (vec2(float(m),float(n)- .5 * float(AA))/ float(AA) * 2.);
      count += plotFunc(fixUV(fragCoord + offset));
    }
  }
  if(count > float(AA * AA) / 2.){
    count = float(AA * AA) - count;
  }
  // 归一化
  count = count * 2. / float(AA * AA);
  color = mix(color,vec3(1.),vec3(count));
  // color = vec3(plotFunc(uv));
  fragColor = vec4(color, 1.0);
}