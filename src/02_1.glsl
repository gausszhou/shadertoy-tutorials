vec3 NumberPlane(vec2 uv){
vec3 color = vec3(0.0);
  vec2 cell = fract(uv);

  if(cell.x <= fwidth(uv.x)){
    color += vec3(1.0);
  }
  if(cell.y <= fwidth(uv.y)){
    color += vec3(1.0);
  }
  if(abs(uv.y) < 2. * fwidth(uv.y)){
    color = vec3(1., 0., 0.);
  }  
  if(abs(uv.x) < 2. * fwidth(uv.x)){
    color = vec3(0., 1., 0.);
  }  
  return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
  vec2 uv = 3.0 * (2.0 * fragCoord - iResolution.xy) / min(iResolution.x,iResolution.y) ;
  vec3 color = NumberPlane(uv);
  fragColor = vec4(color, 1.0);
}