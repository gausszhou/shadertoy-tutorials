// -1 1
vec2 fixUV(in vec2 c){
  return (2. * c - iResolution.xy)/ min(iResolution.x,iResolution.y);
}

float sdfCircle(in vec2 p , float r){
  return length(p) - r;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = fixUV(fragCoord);
    float d = sdfCircle(uv, .7);
    vec3 color =  1. - sign(d) * vec3(.4, .5, .6);
    color *= 1. - exp(-3. * abs(d));
    color *= .8 + .2 * sin(100. * abs(d)); // 等高线
    color = mix(color, vec3(1.),smoothstep(.005, .004, abs(d)));
    fragColor = vec4(color, 1.);
}