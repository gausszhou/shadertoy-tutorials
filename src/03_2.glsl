#define PI 3.14159265

vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  if(abs(uv.x) <=  2. * fwidth(uv.x)){
    color.g = 1.;
  }else if (abs(uv.y) <= 2. * fwidth(uv.y)){
    color.r = 1.;
  } else if (fraction.x < 2. * fwidth(uv.x) || fraction.y < 2. * fwidth(uv.y)){
    color = vec3(1.);
  }
  return color;
}

vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
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
  float T = 3.;
  return sin( 2. * PI / T * x);
}

float funcPlot(in vec2 uv){
  float f = 0.;
  for(float x = 0. ; x <= iResolution.x; x += 1.){
    float fx = fixUV(vec2(x, 0.)).x;
    float nfx = fixUV(vec2(x + 1., 0.)).x;
    f += segment(uv, vec2(fx, func(fx)),vec2(nfx,func(nfx)), fwidth(uv.x));
  }
  return clamp(f, 0., 1.);
}
void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  color = mix(color, vec3(1., 1., 0.), funcPlot(uv)) ;
  fragColor = vec4(color, 1.0);
}