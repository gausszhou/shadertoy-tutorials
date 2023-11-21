void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord / iResolution.xy - vec2(.5);
  float c = 0.0;
  float r = 0.3;
  if (length(uv) < r) {
    c = 1.0;
  }
  fragColor = vec4(vec3(c), 1.0); // rgba
}
