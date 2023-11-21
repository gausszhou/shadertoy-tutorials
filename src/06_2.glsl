//  -1 1
vec2 fixUV(in vec2 c) {
  return (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

float sdfCircle(in vec2 p, float r) { return length(p) - r; }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fixUV(fragCoord);
  float d = sdfCircle(uv, .7);
  vec3 color = 1. - sign(d) * vec3(.4, .5, .6);
  color *= 1. - exp(-3. * abs(d));
  color *= .8 + .2 * sin(100. * abs(d)); // 等高线
  color = mix(color, vec3(1.), smoothstep(.005, .004, abs(d)));
  if (iMouse.z > .1) {
    vec2 m = fixUV(iMouse.xy);
    float currentDistance = abs(sdfCircle(m, .7));
    float circle = smoothstep(.01, 0., abs(length(uv - m) - currentDistance));
    color = mix(color, vec3(1., 1., 0.), circle);
    float circle_dot = smoothstep(.02, .01, length(uv - m));
    color = mix(color, vec3(1., 1., 0.), circle_dot);
  }
  fragColor = vec4(color, 1.);
}