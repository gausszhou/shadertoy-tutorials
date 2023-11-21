#define PI 3.14159265

vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  color = vec3(smoothstep(4.0 * fwidth(uv.x),3.9 * fwidth(uv.x),fraction.x));
  color += vec3(smoothstep(4.0 * fwidth(uv.y),3.9 * fwidth(uv.y),fraction.y));
  color.rb *= 1. - smoothstep(4. * fwidth(uv.x), 3.9 * fwidth(uv.x), abs(uv.x));
  color.gb *= 1. - smoothstep(4. * fwidth(uv.y), 3.9 * fwidth(uv.y), abs(uv.y));
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
  f = smoothstep(w, 0.95 * w, d);
  return f;
}

float func(in float x){
  return smoothstep(.5, 0., x);
}

float funcPlot(in vec2 uv){
  float f = 0.;
  for(float x = 0. ; x <= iResolution.x; x += 1.){
    float fx = fixUV(vec2(x, 0.)).x;
    float nfx = fixUV(vec2(x + 1., 0.)).x;
    f += segment(uv, vec2(fx, func(fx)),vec2(nfx,func(nfx)), 2. * fwidth(uv.x));
  }
  return clamp(f, 0., 1.);
}
void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  color = mix(color, vec3(1., 1., 0.), funcPlot(uv)) ;
  fragColor = vec4(color, 1.0);
}