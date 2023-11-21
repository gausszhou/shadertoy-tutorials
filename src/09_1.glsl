#define WIDHT 1. + .2 * sin(iTime)
#define HEIGHT 1. + .2 * cos(iTime)
//  -2 2
vec2 fixUV(in vec2 c) {
  return 2. * (2. * c - iResolution.xy) / min(iResolution.x, iResolution.y);
}

float sdfRect(in vec2 p, vec2 b) {
  vec2 d = abs(p) - b;
  return length(max(d, 0.)) + min(max(d.x, d.y), 0.);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fixUV(fragCoord);
  float d = sdfRect(uv, vec2(WIDHT, HEIGHT));
  vec3 color = 1. - sign(d) * vec3(.2, .33, .46);
  color *= 1. - exp(-3. * abs(d));
  color *= .8 + .2 * sin(150. * abs(d)); // 等高线
  color = mix(color, vec3(1.), smoothstep(.005, .004, abs(d)));
  if (iMouse.z > .1) {
    vec2 m = fixUV(iMouse.xy);
    float currentDistance = abs(sdfRect(m, vec2(WIDHT, HEIGHT)));
    float circle = smoothstep(.01, 0., abs(length(uv - m) - currentDistance));
    color = mix(color, vec3(1., 1., 0.), circle);
    float circle_dot = smoothstep(.02, .01, length(uv - m));
    color = mix(color, vec3(1., 1., 0.), circle_dot);
  }
  fragColor = vec4(color, 1.);
}