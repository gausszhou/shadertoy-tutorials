vec2 fixUV(in vec2 c){
  return 3. * ( 2. * c - iResolution.xy) / min (iResolution.x, iResolution.y);
}

void mainImage (out vec4 fragColor, in vec2 fragCoord){
    vec2 uv = fixUV(fragCoord);
    vec3 color = vec3(0.);
    color = vec3(smoothstep(1., .95, length(uv)));
    fragColor = vec4(vec3(color),1.0); // rgba
}