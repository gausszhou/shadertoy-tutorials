vec3 Grid(in vec2 uv){
  vec3 color = vec3(0.);
  vec2 fraction = fract(uv);
  if(abs(uv.x) <= 2. * fwidth(uv.x)){
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

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = fixUV(fragCoord);
  vec3 color = Grid(uv);
  fragColor = vec4(color, 1.0);
}